import time
import os
import regex
import rand

#flag -lmpv
#include <mpv/client.h>

struct C.mpv_handle {}
@[typedef]
struct C.mpv_event {
pub:
    event_id        int
    error           int
    reply_user_data u64
    data            voidptr
}

fn C.mpv_create() &C.mpv_handle
fn C.mpv_initialize(&C.mpv_handle) int
fn C.mpv_command(&C.mpv_handle, &&char) int
fn C.mpv_terminate(&C.mpv_handle)
fn C.mpv_set_property(handle &C.mpv_handle, name &char, format int, data voidptr) int
fn C.mpv_get_property(handle &C.mpv_handle, name &char, format int, data voidptr) int
fn C.mpv_set_property_string(handle &C.mpv_handle, name &char, data voidptr) int
fn C.mpv_get_property_string(handle &C.mpv_handle, name &char) &char
fn C.mpv_wait_event(handle &C.mpv_handle, timeout f64) &C.mpv_event
fn C.free(ptr voidptr)

const file_ext := "mp3"
const file_dir := '${os.dir(os.executable())}/resources'
// MPV Format constant (usually 4 for double)
const mpv_format_double = 4

struct AudioPlayer {
mut:
  handle &C.mpv_handle = unsafe { nil }
  target_volume f64 = 50.0
  gradient ?thread
  kill_thread bool
  ease_time time.Duration = time.Duration(2500 * time.millisecond)
  currently_playing string
  query string = "calm"
}
fn (mut p AudioPlayer) set_ease(millis int){
	p.ease_time = time.Duration(millis * time.millisecond)
}

fn (mut p AudioPlayer) init() {
  p.handle = C.mpv_create()
  if p.handle == unsafe { nil } {
    panic('Failed to create mpv context')
  }
  C.mpv_initialize(p.handle)

  //config mpv
  C.mpv_set_property_string(p.handle, 'keep-open'.str, 'yes'.str)
  C.mpv_set_property_string(p.handle, 'loop-playlist'.str, 'inf'.str)
  p.set_volume(p.target_volume)

}

fn (p AudioPlayer) play_now(name string) {
    mut clean_name := name
    if clean_name.ends_with('.mp3') {
        clean_name = clean_name[..clean_name.len - 4]
    }
    println("playing: ${clean_name}")

    arg0 := 'loadfile'.str
    arg1 := '${file_dir}/${clean_name}.${file_ext}'.str
    arg2 := 'replace'.str
    arg3 := voidptr(0) // The mandatory C NULL terminator

    println(arg1)

    cmd_args := [arg0, arg1, arg2, arg3]

    res := C.mpv_command(p.handle, cmd_args.data)

    if res < 0 {
        eprintln('MPV Error: ${res}')
    }
}

fn (mut p AudioPlayer) play(query string) {
	p.kill_thread = true
	for p.gradient != none {time.sleep(10 * time.millisecond)}
	mut songs := get_filenames_from_query(query)
	if songs.len == 0 {
    eprintln('No songs found for: ${query}')
    return
  }
	p.gradient = spawn p.thread_change_song(mut songs)
}

fn (p AudioPlayer) is_active() bool {
    mut idle_active := 0
    C.mpv_get_property(p.handle, 'idle-active'.str, 3, &idle_active)
    return idle_active != 1
}

fn (p AudioPlayer) set_volume(vol f64) {
  C.mpv_set_property_string(p.handle, 'volume'.str, vol.str().str)
}

fn (p AudioPlayer) get_volume() f64 {
    vol := 0.0
    C.mpv_get_property(p.handle, 'volume'.str, mpv_format_double, &vol)
    return vol
}

fn (mut p AudioPlayer) thread_change_song(mut songs []string) {
  p.kill_thread = false // Reset kill switch at start

  // ease in
  if p.is_active() {
    start_vol := p.target_volume
    start_time := time.now()

    for {
      elapsed := time.since(start_time)
      if elapsed >= p.ease_time || p.kill_thread { break }

      ratio := 1.0 - (elapsed.seconds() / p.ease_time.seconds())
      p.set_volume(start_vol * ratio)

      time.sleep(10 * time.millisecond)
    }
  }

  p.play_playlist(mut songs)

  //ease out
  // Note: mpv takes a moment to load; might need a small sleep
  // or to check p.is_active() again after a short delay
  for !p.is_active() {
  	if p.kill_thread { break }
  	time.sleep(10 * time.millisecond)
  }

  if p.is_active() {
    start_time := time.now()
    for {
      elapsed := time.since(start_time)
      if elapsed >= p.ease_time || p.kill_thread { break }

      ratio := elapsed.seconds() / p.ease_time.seconds()
      p.set_volume(p.target_volume * ratio)

      time.sleep(10 * time.millisecond)
    }
    if !p.kill_thread { p.set_volume(p.target_volume) }
  }

  p.gradient = none
}

fn (mut p AudioPlayer) random_from_query(query string) ?string{
	p.query = query
	songs := get_filenames_from_query(query)
	if songs.len < 1 {return none}
	song := songs[rand.int_in_range(0, songs.len) or {0}]
	if songs.len < 2 {p.query = "calm"}
	return song
}

fn list_songs(query string) []string{
	songs := get_filenames_from_query(query)

	mut sanitized := []string{}

	for song in songs {
		mut s := song[query.len..]
		if s[0] == `-` {s = s[1..]}
		mut first_hyphen := 0
		for i:=s.len-1 ; i >= 0; i--{
			if s[i] == `-` {first_hyphen = i}
		}

		cleaned_name := s[..first_hyphen]

		if cleaned_name !in sanitized && cleaned_name != "" { sanitized << cleaned_name }
	}
	return sanitized
}

fn get_filenames_from_query(query string) []string {
	mut q := query

	//ex: calm.suspenseful.
	//or: c!
	for q.contains(r".") {
		q = q.replace(r".", r".*").replace(r"!", r"")
	}

	q += r".*$"
	q = r"^" + q

	mut re := regex.regex_opt(q) or { panic(err) }

	entries := os.ls(file_dir) or {
		return []
	}
	matches := entries.filter(re.matches_string(it))
	return matches
}

fn (p AudioPlayer) play_playlist(mut songs []string) {
    if songs.len == 0 { return }

    rand.shuffle(mut songs) or { }

    for i, song in songs {
        mode := if i == 0 { 'replace' } else { 'append-play' }

        path := '${file_dir}/${song}'
        arg0 := 'loadfile'.str
        arg1 := path.str
        arg2 := mode.str
        arg3 := voidptr(0)

        cmd_args := [arg0, arg1, arg2, arg3]
        C.mpv_command(p.handle, cmd_args.data)
    }

    C.mpv_command(p.handle, ['playlist-shuffle'.str, voidptr(0)].data)
}
