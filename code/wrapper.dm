

//------------------------------------------------------------------------------

world
	//version = N // Turn off debug before release!

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
