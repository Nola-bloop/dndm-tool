import rand

fn equipment_random_ac(mod i8) i32{
	ac := i8(10)
	d4 := rand.i32_in_range(1,5) or {1}
	other := rand.i32_in_range(-1,2) or {0}
	return ac + mod + d4 + other
}
fn equipment_random_bonus_lvl() i8{
	result := rand.i32_in_range(1,101) or {1}
	return match true {
		result > 96 { 3 }
		result > 60 { 2 }
		else { 1 }
	}
}

fn equipment_rnd_in_arr(arr []fn(string)string) string{
	return arr[rand.i32_in_range(0,arr.len)or{0}]("")
}

fn get_random_equipment() string{
	type := rand.i32_in_range(1,3) or {1}
	bonus_flag := rand.i32_in_range(1,101) or {1} > 60
	match type {
		1 {
			return '${equipment_rnd_in_arr(armor_types)} ${if bonus_flag {'${equipment_rnd_in_arr(equipment_bonus)}'} else {""} }'
		}
		2{
			return '${equipment_rnd_in_arr(weapon_types)} ${if bonus_flag {'${equipment_rnd_in_arr(equipment_bonus)}'} else {""} }'
		}
		else{ return "Error (1)."}
	}
}

const equipment_bonus := [
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Athletism' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Acrobatics' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Stealth' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Sleight of Hand' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Arcana' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} History' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Investigation' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Nature' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Religion' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Animal handling' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Insight' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Medicine' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Perception' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Survival' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Deception' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Intimidation' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Performance' }
	fn (str string) string { return '+${equipment_random_bonus_lvl()} Persuasion' }
]

const armor_types := [
	fn (str string) string { return 'helmet clothing' }
	fn (str string) string { return 'helmet light armor' }
	fn (str string) string { return 'helmet heavy armor' }
	fn (str string) string { return 'leggings clothing' }
	fn (str string) string { return 'leggings light armor' }
	fn (str string) string { return 'leggings medium armor' }
	fn (str string) string { return 'leggings heavy armor' }
	fn (str string) string { return 'boots clothing' }
	fn (str string) string { return 'boots heavy armor' }
	fn (str string) string { return 'chestplate clothing AC${equipment_random_ac(-1)}' }
	fn (str string) string { return 'chestplate  light armor AC${equipment_random_ac(0)}' }
	fn (str string) string { return 'chestplate medium armor AC${equipment_random_ac(1)}' }
	fn (str string) string { return 'chestplate heavy armor AC${equipment_random_ac(2)}' }
]

const weapon_types := [
	fn (str string) string { return 'Club' }
	fn (str string) string { return 'Dagger' }
	fn (str string) string { return 'Greatclub' }
	fn (str string) string { return 'Handaxe' }
	fn (str string) string { return 'Javelin' }
	fn (str string) string { return 'Light hammer' }
	fn (str string) string { return 'Mace' }
	fn (str string) string { return 'Quarterstaff' }
	fn (str string) string { return 'Sickle' }
	fn (str string) string { return 'Spear' }
	fn (str string) string { return 'Crossbow, light' }
	fn (str string) string { return 'Dart' }
	fn (str string) string { return 'Shortbow' }
	fn (str string) string { return 'Sling' }
	fn (str string) string { return 'Battleaxe' }
	fn (str string) string { return 'Glaive' }
	fn (str string) string { return 'Greataxe' }
	fn (str string) string { return 'Greatsword' }
	fn (str string) string { return 'Halberd' }
	fn (str string) string { return 'Lance' }
	fn (str string) string { return 'Longsword' }
	fn (str string) string { return 'Maul' }
	fn (str string) string { return 'Pike' }
	fn (str string) string { return 'Rapier' }
	fn (str string) string { return 'Scimitar' }
	fn (str string) string { return 'Shortsword' }
	fn (str string) string { return 'Spiked Chain' }
	fn (str string) string { return 'Trident' }
	fn (str string) string { return 'War pick' }
	fn (str string) string { return 'Warhammer' }
	fn (str string) string { return 'Whip' }
	fn (str string) string { return 'War Scythe' }
	fn (str string) string { return 'Blowgun' }
	fn (str string) string { return 'Crossbow, hand' }
	fn (str string) string { return 'Crossbow, heavy' }
	fn (str string) string { return 'Great Bow' }
	fn (str string) string { return 'Longbow' }
	fn (str string) string { return 'Net' }
	fn (str string) string { return 'Morningstar' }
	fn (str string) string { return 'Shortsword' }
]
