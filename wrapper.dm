world
	hub = "iainperegrine.casualquest"
	hub_password = "C28PnxSyqL1ShCtm"
	version = 40 // Turn off debug before release!

	view = 21

	New()
		. = ..()
		name = "Casual Quest - Version 1.[version]"

		game = new()

#ifdef DEBUG
		spawn(20)
			// A secret warning so I don't forget to disable debug mode
			world<<"<span style='font-weight:bold;color:#DD0000'>What a beautiful day in the world of Illuna!</span>"
#endif

var/server_name

mob/density = 0

client
	#ifndef DEBUG
	control_freak = TRUE
	#endif

	preload_rsc = "http://files.byondhome.com/iainperegrine/casual_quest_rsc_38.zip"

	verb
		force_reboot()
			set name = ".force_reboot"
#ifndef DEBUG
			if(!(ckey in list("iainperegrine", "cauti0n","williferd", "darkcampainger")))
				return
#endif
			var/phrase = input(src, "Type the word \"reboot\" to reboot the world","CQ Admin Panel") as null|text
			if(lowertext(phrase) == "reboot") world.Reboot()

		forcereboot()
			set name = ".forcereboot"
			force_reboot()

		change_class()
			set name = ".change"
#ifndef DEBUG
			if(!(ckey in list("iainperegrine", "cauti0n","williferd")))
				return
#endif
			var/class_path = input(src,"Select a class","CQ Admin Panel") as null|anything in (typesof(/game/hero)-/game/hero)
			if(!class_path) return

			game.add_hero(src, class_path)
			src.hero.output_class_link(world, src)

		change_other()
			set name = ".other"
#ifndef DEBUG
			if(!(ckey in list("iainperegrine", "cauti0n","williferd")))
				return
#endif
			var/list/clients = new()
			for(var/client/C)
				clients.Add(C)

			var/client/who = input(src, "Pick a player to change", "CQ Admin Panel") as null|anything in clients
			if(!who) return

			var/class_path = input(src,"Select a class","CQ Admin Panel") as null|anything in (typesof(/game/hero)-/game/hero)
			if(!class_path) return

			game.add_hero(who, class_path)
			who.hero.output_class_link(world, who)

		start_wave()
			set name = ".wave"
#ifndef DEBUG
			if(!(ckey in list("iainperegrine", "cauti0n","williferd")))
				return
#endif
			var/start_wave = input(src, "Choose a Starting Wave", "Yada Yada", 100) as num
			start_wave = round(start_wave)
			start_wave = max(1, start_wave)
			game.join(src, start_wave)

	East(     ) return
	Southeast() return
	South(    ) return
	Southwest() return
	West(     ) return
	Northwest() return
	North(    ) return
	Northeast() return

game/map/mover
	icon = 'rectangles.dmi'
	icon_state = "square-grey_32"


game/map/mover/gridded{
	translate(x_amo, y_amo){
		if(     x_amo && !y_amo){
			var/asdf = c.y % (TILE_HEIGHT/2)
			if(asdf){
				if((asdf - (TILE_HEIGHT/4)) >= 0){
					y_amo++
					}
				else{
					y_amo--
					}
				}
			}
		else if(y_amo && !x_amo){
			var/asdf = c.x % (TILE_WIDTH/2)
			if(asdf){
				if((asdf - (TILE_WIDTH/4)) >= 0){
					x_amo++
					}
				else{
					x_amo--
					}
				}
			}
		. = ..()
		}
	}
client{
	var/game/hero/hero

	proc{
		intelligence(var/game/map/mover/M){
			if(!hero.projectile){
				var/x_translate = 0
				var/y_translate = 0
				var/_check = key_state | key_pressed
				//if(    (EAST  & _check) && (SHIFT & _check)){ hero.dir = EAST }
				if(EAST  & _check){ x_translate += hero.speed}
				//if(    (WEST  & _check) && (SHIFT & _check)){ hero.dir = WEST }
				if(WEST  & _check){ x_translate -= hero.speed}
				//if(    (NORTH & _check) && (SHIFT & _check)){ hero.dir = NORTH}
				if(NORTH & _check){ y_translate += hero.speed}
				//if(    (SOUTH & _check) && (SHIFT & _check)){ hero.dir = SOUTH}
				if(SOUTH & _check){ y_translate -= hero.speed}
				M.px_move(x_translate, y_translate)
				if(PRIMARY & key_pressed){          hero.shoot() }
				else if(SECONDARY & key_pressed && (hero.skill1)){
					if(hero.aura >= hero.skill1_cost){
						hero.adjust_aura(-hero.skill1_cost)
						var/game/hero/skill/skill1 = new hero.skill1(hero)
						skill1.activate()
						}
					}
				else if(TERTIARY & key_pressed && (hero.skill2)){
					if(hero.aura >= hero.skill2_cost){
						hero.adjust_aura(-hero.skill2_cost)
						var/game/hero/skill/skill2 = new hero.skill2(hero)
						skill2.activate()
						}
					}
				else if(QUATERNARY & key_pressed && (hero.skill3)){
					if(hero.aura >= hero.skill3_cost){
						hero.adjust_aura(-hero.skill3_cost)
						var/game/hero/skill/skill3 = new hero.skill3(hero)
						skill3.activate()
						}
					}
				else if(HELP_KEY & key_pressed){ hero.call_help()}
				}
			clear_keys()
			}
		}
	}