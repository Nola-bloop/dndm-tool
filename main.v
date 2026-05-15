module main

import term
import readline


const commands := {
	"p!" : fn (mut p AudioPlayer, args ...string){
		if args.len < 1 { return }
		p.play_now(args[0])
	}
	"p" : fn (mut p AudioPlayer, args ...string){
		if args.len < 1 { return }
		p.play(args[0])
	}
	"pl" : fn (mut p AudioPlayer, args ...string){
		songs := list_songs(args[0] or {""})
		for s in songs {
			println('- ${s}')
		}
	}
	"pv" : fn (mut p AudioPlayer, args ...string){
		spawn p.thread_change_vol(args[0].f64())
	}
	"grad" : fn (mut p AudioPlayer, args ...string){
		p.set_ease(args[0].int())
	}
	"common" : fn (mut p AudioPlayer, args ...string){
		if args.len < 1 { println(get_random_equipment()) return }

		for _ in 0 .. args[0].int(){
			println(get_random_equipment())
		}
	}
	"char" : fn (mut p AudioPlayer, args ...string){
    if args.len < 1 { println(get_character()) return }

  	for _ in 0 .. args[0].int(){
  		println(get_character())
  	}
	}
}

fn main() {
    mut player := AudioPlayer{}
    player.init()

   	println("waiting...")
    print(":")
    mut skip_cls := true
    mut last_cmd := ""
    for true {
    	if skip_cls {skip_cls = true} else {term.clear()}
    	mut input := readline.read_line("")!
     	if input == "" { input = last_cmd } else {last_cmd = input }
     	mut args := input.split(" ")
      command := args.pop_left()
      if command == "q" {return}
      else if command in ["h", "help"] { for k, _ in commands {println(k)} }
      else if command in commands {
      	commands[command](mut player, ...args)
      }
      else{
	     	println("Commande invalide.")
			  skip_cls = true
      }
    }
}
