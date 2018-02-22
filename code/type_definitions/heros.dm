

//------------------------------------------------------------------------------

game/var
	list/hero_archetypes = list(
		"0000" = /game/hero/_blank,
		"1000" = /game/hero/knight,
		"2000" = /game/hero/dragoon,
		"0100" = /game/hero/acolyte,
		"1100" = /game/hero/paladin,
		"2100" = list(/game/hero/dragoon, /game/hero/paladin),
		"0200" = /game/hero/cleric,
		"1200" = list(/game/hero/cleric, /game/hero/paladin),
		"0010" = /game/hero/mage,
		"1010" = /game/hero/dark_knight,
		"2010" = list(/game/hero/dragoon, /game/hero/dark_knight),
		"0110" = /game/hero/druid,
		"0210" = list(/game/hero/cleric, /game/hero/druid),
		"0020" = /game/hero/wizard,
		"1020" = list(/game/hero/wizard, /game/hero/dark_knight),
		"0120" = list(/game/hero/wizard, /game/hero/druid),
		"0001" = /game/hero/archer,
		"1001" = /game/hero/barbarian,
		"2001" = list(/game/hero/dragoon, /game/hero/barbarian),
		"0101" = /game/hero/bard,
		"0201" = list(/game/hero/cleric, /game/hero/bard),
		"0011" = /game/hero/nomad,
		"0021" = list(/game/hero/wizard, /game/hero/nomad),
		"0002" = /game/hero/pirate,
		"1002" = list(/game/hero/pirate, /game/hero/barbarian),
		"0102" = list(/game/hero/pirate, /game/hero/bard),
		"0012" = list(/game/hero/pirate, /game/hero/nomad),
	)
	list/subscriber_archetypes = list(
		"0000" = /game/hero/_blank,
		"1000" = /game/hero/knight,
		"2000" = /game/hero/dragoon,
		"3000" = /game/hero/royal_knight,
		"0100" = /game/hero/acolyte,
		"1100" = /game/hero/paladin,
		"2100" = /game/hero/crusader,
		"0200" = /game/hero/cleric,
		"1200" = /game/hero/templar,
		"0300" = /game/hero/high_priest,
		"0010" = /game/hero/mage,
		"1010" = /game/hero/dark_knight,
		"2010" = /game/hero/dark_lancer,
		"0110" = /game/hero/druid,
		"1110" = /game/hero/hero,
		"0210" = /game/hero/sage,
		"0020" = /game/hero/wizard,
		"1020" = /game/hero/warlock,
		"0120" = /game/hero/lich,
		"0030" = /game/hero/sorcerer,
		"0001" = /game/hero/archer,
		"1001" = /game/hero/barbarian,
		"2001" = /game/hero/warlord,
		"0101" = /game/hero/bard,
		"1101" = /game/hero/monk,
		"0201" = /game/hero/minstrel,
		"0011" = /game/hero/nomad,
		"1011" = /game/hero/berserker,
		"0111" = /game/hero/dervish,
		"0021" = /game/hero/conjurer,
		"0002" = /game/hero/pirate,
		"1002" = /game/hero/assassin,
		"0102" = /game/hero/gypsy,
		"0012" = /game/hero/vampire,
		"0003" = /game/hero/rogue,
		"1111" = /game/hero/rebel,
	)
/*

K P M R


		list/subscriber_archetypes = list(
			"0000" = /game/hero/_blank,
			"1000" = /game/hero/knight,
			"2000" = /game/hero/dragoon,
			"3000" = /game/hero/royal_knight,
			"4000"
			"0100" = /game/hero/acolyte,
			"1100" = /game/hero/paladin,
			"2100" = /game/hero/crusader,
			"3100"
			"0200" = /game/hero/cleric,
			"1200" = /game/hero/templar,
			"2200"
			"0300" = /game/hero/high_priest,
			"1300"
			"0400"
			"0010" = /game/hero/mage,
			"1010" = /game/hero/dark_knight,
			"2010" = /game/hero/dark_lancer,
			"3010"
			"0110" = /game/hero/druid,
			"1110" = /game/hero/hero,
			"2110" = ??????????????????????
			"0210" = /game/hero/sage,
			"1210" = ??????????????????????
			"0310"
			"0020" = /game/hero/wizard,
			"1020" = /game/hero/warlock,
			"2020"
			"0120" = /game/hero/lich,
			"1120" = ??????????????????????
			"0220"
			"0030" = /game/hero/sorcerer,
			"1030"
			"0130"
			"0040"
			"0001" = /game/hero/archer,
			"1001" = /game/hero/barbarian,
			"2001" = /game/hero/warlord,
			"3001"
			"0101" = /game/hero/bard,
			"1101" = /game/hero/monk,
			"2101" = ??????????????????????
			"0201" = /game/hero/minstrel,
			"1201" = ??????????????????????
			"0301"
			"0011" = /game/hero/nomad,
			"1011" = /game/hero/berserker,
			"2011" = ??????????????????????
			"0111" = /game/hero/dervish,
			"1111" = &&&&&&&&&&&&&&&&&&&&&&
			"0211" = ??????????????????????
			"0021" = /game/hero/conjurer,
			"1021" = ??????????????????????
			"0121" = ??????????????????????
			"0031"
			"0002" = /game/hero/pirate,
			"1002" = /game/hero/assassin,
			"2002"
			"0102" = /game/hero/gypsy,
			"1102" = ??????????????????????
			"0202"
			"0012" = /game/hero/vampire,
			"1012" = ??????????????????????
			"0112" = ??????????????????????
			"0022"
			"0003" = /game/hero/rogue,
			"1003"
			"0103"
			"0013"
			"0004"
			)


	*/

game/hero
	var
		client_key
		description = null
		speed = 1
		reverseDamage = 0
		level_knight = 0
		level_priest = 0
		level_mage   = 0
		level_rogue  = 0
		skill1_cost=0
		skill2_cost=0
		skill3_cost=0
		game/hero/skill/skill1
		game/hero/skill/skill2
		game/hero/skill/skill3
		special_skill=0
		//SPECIAL VARIABLES
		game/hero/summon/genie/genie
		bat = FALSE
		disappeared = FALSE
		arr_overlay
		dash = FALSE
		endwave = FALSE
		javelin = FALSE

	proc/call_help()
		overlays.Add(game.help_overlay)
		spawn(25)
			overlays.Remove(game.help_overlay)

	proc
		cast_time(var/time = 0)
			intelligence = new /game/map/mover/intelligence/cast(time)
		time_out(var/time = 0)
			intelligence = new /game/map/mover/intelligence/freezer(time)


//-- Hero Type Defs ------------------------------------------------------------

game/hero{
	gm{
		name = "Debug"
		icon = 'gm.dmi'
		front_protection = TRUE
		aura_rate = 75
		max_health = 12
		max_aura = 12
		speed = 2
		projectile_type = /game/hero/projectile/gold_axe
		skill1_cost = 1
		skill3_cost = 1
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/kill_all
		skill3 = /game/hero/skill/fire_snake
		call_help(){
			if(game.help_overlay in overlays){
				var/game/enemy/shogun/S = new()
				S.c.x = 128
				S.c.y = 128

				/*for(var/game/enemy/E){
					E.die()
					}*/
				}
			else{
				. = ..()
				}
			}
		}
	rock{
		name="Pet Rock"
		icon = 'rock.dmi'
		projectile_type = /game/hero/projectile/wood_axe
		px_move(x_amo, y_amo){
			if(x_amo > 0){
				dir = EAST
				return
				}
			if(x_amo < 0){
				dir = WEST
				return
				}
			if(y_amo > 0){
				dir = NORTH
				return
				}
			if(y_amo < 0){
				dir = SOUTH
				return
				}
			}
		}
	dead{
		New(){
			. = ..()
			spawn(1){
				adjust_health(-2*max_health)
				}
			}
		}
	_blank{
		name = "Adventurer"
		icon = '_blank.dmi'
		tier = 0
		}
	_member{
		name = "Member's Adventurer"
		icon = '_member.dmi'
		tier = 0
		front_protection = TRUE
		max_aura = 1
		aura_rate = 1000
		skill1_cost = 1
		skill1 = /game/hero/skill/heal_cherry
		}
	_regressia{
		name = "Hero of Regressia"
		icon = '_regressia.dmi'
		tier = 0
		front_protection = TRUE
		max_health = 4
		max_aura = 1
		aura_rate = 1000
		projectile_type = /game/hero/projectile/sword
		skill1_cost = 1
		skill1 = /game/hero/skill/heal
		}
	_hazordhu{
		name = "Hazordhu Orc"
		icon = '_hazordhu.dmi'
		tier = 0
		max_aura = 4
		aura_rate = 250
		projectile_type = /game/hero/projectile/wood_axe
		skill1_cost = 4
		skill1 = /game/hero/skill/flame_arrow
		}
	_decadence{
		icon = '_decadence.dmi'
		name = "Decadence Crossbowman"
		tier = 0
		max_aura = 2
		aura_rate = 250
		projectile_type = /game/hero/projectile/crossbow
		skill1_cost = 2
		skill1 = /game/hero/_decadence/grenade
		grenade{
			parent_type = /game/hero/skill
			name = "Grenade"
			description = {"Throws a grenade which explodes shortly afterward, dealing ~p points of damage to any enemy or player nearby. Explosion does extra damage to snaking enemies."}
			potency = 2
			activate(){
				if(owner.disappeared){ return}
				new /game/hero/_decadence/grenade_proj/(owner)
				}
			}
		grenade_proj{
			parent_type = /game/hero/projectile/bomb
			icon = '_decadence.dmi'
			icon_state = "grenade"
			var{
				speed = 8
				}
			New(){
				. = ..()
				dir = owner.dir
				switch(dir){
					if(NORTH){
						vel.x = 0
						vel.y = speed
						}
					if(SOUTH){
						vel.x = 0
						vel.y = -speed
						}
					if(EAST ){
						vel.x = speed
						vel.y = 0
						}
					if(WEST ){
						vel.x = -speed
						vel.y = 0
						}
					}
				}
			behavior(){
				. = ..()
				if(vel.x){
					vel.x -= sign(vel.x)
					}
				if(vel.y){
					vel.y -= sign(vel.y)
					}
				}
			}
		}
	_plunder_gnome{
		name="Plunder Gnome"
		description={""}
		tier = 0
		icon = 'gnome_red.dmi'
		aura_rate = 1000
		max_health = 4
		speed = 2
		x_offset = -3
		width = 10
		height = 10
		projectile_type = /game/hero/projectile/fist
		}
	knight{
		name="Knight"
		description={"<b>Notes:</b> All classes with shields can block projectiles. The character must be facing the projectile, and neither attacking nor using a skill."}
		tier = 1

		level_knight = 1
		icon = 'knight.dmi'
		max_health = 10
		max_aura = 0
		projectile_type = /game/hero/projectile/sword
		front_protection = TRUE
		}
	dragoon{
		name="Dragoon"
		description={""}
		tier = 2

		level_knight = 2
		icon = 'dragoon.dmi'
		max_health = 10
		max_aura = 0
		projectile_type = /game/hero/projectile/lance
		front_protection = TRUE
		skill2 = /game/hero/skill/proj_wood_axe
		}
	royal_knight{
		name="Royal Knight"
		description={""}
		tier = 3

		level_knight = 3
		icon = 'royal_knight.dmi'
		max_health = 14
		max_aura = 0
		projectile_type = /game/hero/projectile/lance
		front_protection = TRUE
		skill1 = /game/hero/skill/proj_gold_sword
		skill2 = /game/hero/skill/proj_axe
		}
	acolyte{
		name="Acolyte"
		description={""}
		tier = 1

		level_priest = 1
		icon = 'acolyte.dmi'
		max_health = 6
		max_aura = 3
		skill1_cost = 1
		skill2_cost = 1
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/light
		}
	paladin{
		name="Paladin"
		description={""}
		tier = 2

		level_knight = 1
		level_priest = 1
		icon = 'paladin.dmi'
		max_health = 8
		max_aura = 3
		projectile_type = /game/hero/projectile/sword
		front_protection = TRUE
		skill1_cost = 1
		skill1 = /game/hero/skill/heal
		}
	crusader{
		name="Crusader"
		description={""}
		tier = 3

		level_knight = 2
		level_priest = 1
		icon = 'crusader.dmi'
		max_health = 10
		max_aura = 4
		projectile_type = /game/hero/projectile/lance
		front_protection = TRUE
		skill1_cost = 1
		skill2_cost = 0
		skill1 = /game/hero/skill/light2
		skill2 = /game/hero/skill/proj_axe
		}
	cleric{
		name="Cleric"
		description={""}
		tier = 2

		level_priest = 2
		icon = 'cleric.dmi'
		max_health = 6
		max_aura = 6
		aura_rate = 208
		skill1_cost = 1
		skill2_cost = 1
		skill3_cost = 6
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/light2
		skill3 = /game/hero/skill/life
		}
	templar{
		name="Templar"
		description={""}
		tier = 3

		level_knight = 1
		level_priest = 2
		icon = 'templar.dmi'
		max_health = 8
		max_aura = 6
		aura_rate = 256
		projectile_type = /game/hero/projectile/sword
		front_protection = TRUE
		skill1_cost = 1
		skill2_cost = 1
		skill3_cost = 6
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/light
		skill3 = /game/hero/skill/life
		}
	high_priest{
		name="High Priest"
		description={""}
		tier = 3

		level_priest = 3
		icon = 'high_priest.dmi'
		max_health = 7
		max_aura = 11
		aura_rate = 150
		skill1_cost = 1
		skill2_cost = 1
		skill3_cost = 2
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/light2
		skill3 = /game/hero/skill/life
		}
	mage{
		name="Mage"
		description={""}
		tier = 1

		level_mage   = 1
		icon = 'mage.dmi'
		max_health = 6
		max_aura = 5
		aura_rate = 75
		projectile_type = /game/hero/projectile/wood_sword
		skill1_cost = 1
		skill2_cost = 2
		skill3_cost = 3
		skill1 = /game/hero/skill/magic1
		skill2 = /game/hero/skill/magic2
		skill3 = /game/hero/skill/seeker
		}
	dark_knight{
		name="Dark Knight"
		description={""}
		tier = 2

		level_knight = 1
		level_mage   = 1
		icon = 'dark_knight.dmi'
		max_health = 10
		max_aura = 4
		aura_rate = 200
		projectile_type = /game/hero/projectile/sword
		front_protection = TRUE
		skill1_cost = 1
		skill2_cost = 4
		skill1 = /game/hero/skill/magic_sword
		skill2 = /game/hero/skill/invulnerable
		}
	dark_lancer{
		name="Dark Lancer"
		description={""}
		tier = 3

		level_knight = 2
		level_mage   = 1
		icon = 'dark_lancer.dmi'
		max_health = 10
		max_aura = 4
		aura_rate = 200
		projectile_type = /game/hero/projectile/lance
		front_protection = TRUE
		skill1_cost = 1
		skill2_cost = 0
		skill3_cost = 4
		skill1 = /game/hero/skill/magic_sword
		skill2 = /game/hero/skill/proj_wood_axe
		skill3 = /game/hero/skill/invulnerable
		}
	druid{
		name="Druid"
		description={""}
		tier = 2

		level_priest = 1
		level_mage   = 1
		icon = 'druid.dmi'
		max_health = 6
		max_aura = 4
		aura_rate = 130
		projectile_type = /game/hero/projectile/wood_sword
		skill1_cost = 1
		skill2_cost = 1
		skill3_cost = 3
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/magic2
		skill3 = /game/hero/skill/seeker
		}
	hero{
		name="Hero"
		description={""}
		tier = 3

		level_knight = 1
		level_priest = 1
		level_mage   = 1
		icon = 'hero.dmi'
		max_health = 8
		max_aura = 4
		aura_rate = 130
		projectile_type = /game/hero/projectile/sword
		front_protection = TRUE
		skill1_cost = 1
		skill2_cost = 1
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/magic_sword
		}
	sage{
		name="Sage"
		description={""}
		tier = 3

		level_priest = 2
		level_mage   = 1
		icon = 'sage.dmi'
		max_health = 6
		max_aura = 4
		aura_rate = 75
		projectile_type = /game/hero/projectile/wood_sword
		skill1_cost = 2
		skill2_cost = 2
		skill3_cost = 4
		skill1 = /game/hero/skill/heal_orb
		skill2 = /game/hero/skill/aura_orb
		skill3 = /game/hero/skill/fire_orb
		}
	wizard{
		name="Wizard"
		description={""}
		tier = 2

		level_mage   = 2
		icon = 'wizard.dmi'
		max_health = 6
		max_aura = 12
		aura_rate = 75
		projectile_type = /game/hero/projectile/wood_sword
		skill1_cost = 2
		skill2_cost = 3
		skill3_cost = 5
		skill1 = /game/hero/skill/magic2
		skill2 = /game/hero/skill/seeker
		skill3 = /game/hero/skill/fire_large
		}
	warlock{
		name="Warlock"
		description={""}
		tier = 3

		level_knight = 1
		level_mage   = 2
		icon = 'warlock.dmi'
		max_health = 6
		max_aura = 6
		aura_rate = 85
		front_protection = TRUE
		projectile_type = /game/hero/projectile/sword
		skill1_cost = 1
		skill2_cost = 2
		skill3_cost = 3
		skill1 = /game/hero/skill/magic_sword
		skill2 = /game/hero/skill/seeker
		skill3 = /game/hero/skill/controlled_sword
		}
	lich{
		name="Necromancer"
		description={""}
		tier = 3

		level_priest = 1
		level_mage   = 2
		icon = 'lich.dmi'
		max_health = 6
		max_aura = 6
		aura_rate = 50
		skill1_cost = 2
		skill2_cost = 6
		skill3_cost = 2
		skill1 = /game/hero/skill/seeker
		skill2 = /game/hero/skill/summon_skeleton
		skill3 = /game/hero/skill/lich_life

		skeleton{
			parent_type = /game/hero
			level_knight = 4
			level_priest = 4
			level_mage   = 4
			level_rogue  = 4
			icon = 'skeleton.dmi'
			tombing = FALSE
			max_health = 8
			var{
				hero_type
				}
			New(){
				. = ..()
				projectile_type = pick(
					/game/hero/projectile/lance,
					/game/hero/projectile/axe,
					/game/hero/projectile/bone,
					)
				}
			proc{
				restore(){
					if(!player || !hero_type){
						return
						}
					var/game/hero/H = new hero_type()
					H.player = player
					H.player.hero = H
					H.player.eye = game.eye
					H.c.x = c.x
					H.c.y = c.y
					H.health = min(H.max_health, health)
					H.aura = 0
					H.invulnerable = INVULNERABLE_TIME
					H.adjust_health(0)
					H.adjust_aura(1)
					H.redraw()
					game.heros.Remove(src)
					. = H
					var/game/hero/H2 = src
					src = null
					H2.Del()
					}
				}
			}
		}
	sorcerer{
		name="Sorcerer"
		description={""}
		tier = 3

		level_mage   = 3
		icon = 'sorcerer.dmi'
		max_health = 6
		max_aura = 12
		aura_rate = 50
		projectile_type = /game/hero/projectile/wood_sword
		skill1_cost = 2
		skill2_cost = 3
		skill3_cost = 12
		skill1 = /game/hero/skill/magic2
		skill2 = /game/hero/skill/seeker
		skill3 = /game/hero/skill/fire_snake
		}
	archer{
		name="Archer"
		description={""}
		tier = 1

		level_rogue  = 1
		icon = 'archer.dmi'
		max_health = 6
		max_aura = 0
		speed = 2
		projectile_type = /game/hero/projectile/arrow
		skill1 = /game/hero/skill/proj_wood_sword
		skill2 = /game/hero/skill/proj_wood_sword
		skill3 = /game/hero/skill/proj_wood_sword
		}
	barbarian{
		name="Barbarian"
		description={""}
		tier = 2

		level_knight = 1
		level_rogue  = 1
		icon = 'barbarian.dmi'
		max_health = 12
		max_aura = 0
		projectile_type = /game/hero/projectile/axe
		}
	warlord{
		name="Warlord"
		description={""}
		tier = 3

		level_knight = 2
		level_rogue = 1
		icon = 'warlord.dmi'
		max_health = 14
		max_aura = 10
		aura_rate = 15
		projectile_type = /game/hero/projectile/axe
		skill1 = /game/hero/skill/proj_ball
		}
	bard{
		name="Bard"
		description={""}
		tier = 2

		level_priest = 1
		level_rogue  = 1
		icon = 'bard.dmi'
		max_health = 6
		max_aura = 3
		speed = 2
		projectile_type = /game/hero/projectile/note
		skill1_cost = 3
		skill1 = /game/hero/skill/protect
		skill2 = /game/hero/skill/proj_wood_sword
		skill3 = /game/hero/skill/proj_wood_sword
		}
	monk{
		name="Monk"
		description={""}
		tier = 3

		level_knight = 1
		level_priest = 1
		level_rogue  = 1
		icon = 'monk.dmi'
		speed = 2
		max_health = 6
		max_aura = 2
		speed = 2
		aura_rate = 200
		projectile_type = /game/hero/projectile/fist
		skill1_cost = 1
		skill2_cost = 1
		skill3_cost = 0
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/push_fist
		skill3 = /game/hero/skill/mana_heal
		}
	minstrel{
		name="Minstrel"
		description={""}
		tier = 3

		level_priest = 2
		level_rogue  = 1
		icon = 'minstrel.dmi'
		max_health = 6
		max_aura = 4
		speed = 2
		aura_rate = 125
		projectile_type = /game/hero/projectile/note
		skill1_cost = 3
		skill2_cost = 4
		skill1 = /game/hero/skill/protect
		skill2 = /game/hero/skill/barrier_circle
		skill3 = /game/hero/skill/proj_wood_sword
		}
	nomad{
		name="Nomad"
		description={""}
		tier = 2

		level_mage = 1
		level_rogue = 1
		icon = 'nomad.dmi'
		speed = 2
		max_health = 6
		max_aura = 3
		aura_rate = -1
		projectile_type = /game/hero/projectile/saber
		skill1_cost = 1
		skill1 = /game/hero/skill/summon_genie
		adjust_aura(var/amount){
			if(amount > 0){ amount = 0}
			. = ..()
			}
		}
	berserker{
		name="Berserker"
		description={""}
		tier = 3

		level_knight = 1
		level_mage = 1
		level_rogue  = 1
		icon = 'berserker.dmi'
		max_health = 4
		max_aura = 5
		aura_rate = 150
		projectile_type = /game/hero/projectile/axe
		adjust_health(amount){
			if(amount >= 0 || !aura){
				return ..()
				}
			if(aura){
				var/aura_component = min(aura, -amount)
				adjust_aura(-aura_component)
				var/remainder = (-amount) - (aura_component)
				adjust_health(-remainder)
				}
			}
		}
	dervish{
		name="Dervish"
		description={""}
		tier = 3

		level_priest = 1
		level_mage   = 1
		level_rogue  = 1
		icon = 'dervish.dmi'
		speed = 2
		max_health = 6
		max_aura = 4
		projectile_type = /game/hero/projectile/saber
		skill1_cost = 1
		skill2_cost = 3
		skill3_cost = 4
		skill1 = /game/hero/skill/heal
		skill2 = /game/hero/skill/fire_dance
		skill3 = /game/hero/skill/freeze_dance
		}
	conjurer{
		name="Conjurer"
		description={""}
		tier = 3

		level_mage = 2
		level_rogue = 1
		icon = 'conjurer.dmi'
		max_health = 6
		max_aura = 6
		aura_rate = 200
		projectile_type = /game/hero/projectile/wood_sword
		skill1_cost = 3
		skill2_cost = 4
		skill3_cost = 6
		skill1 = /game/hero/skill/summon_fire
		skill2 = /game/hero/skill/summon_wind
		skill3 = /game/hero/skill/summon_wind_golem
		}
	pirate{
		name="Pirate"
		description={""}
		tier = 2

		level_rogue = 2
		icon = 'pirate.dmi'
		max_health = 6
		max_aura = 2
		aura_rate = 100
		projectile_type = /game/hero/projectile/saber
		skill2_cost = 2
		skill3_cost = 1
		skill1 = /game/hero/skill/proj_arrow
		skill2 = /game/hero/skill/bomb
		skill3 = /game/hero/skill/jim_and_the_pirates
		speed = 2
		New(){
			. = ..()
			var/obj/temp_o = new()
			var/image/help = image(icon, null, "help", MOB_LAYER+1)
			help.pixel_y += TILE_HEIGHT
			temp_o.overlays.Add(help)
			for(var/appearance in temp_o.overlays){
				arr_overlay = appearance
				}
			del temp_o
			}
		bard{
			level_rogue = 2
			icon = 'pirate_bard.dmi'
			max_health = 6
			max_aura = 2
			aura_rate = 100
			speed = 2
			skill1_cost = 1
			skill2_cost = 2
			skill3_cost = 1
			skill1 = /game/hero/skill/proj_note
			skill2 = /game/hero/skill/note_orb
			skill3 = /game/hero/skill/pirate_mode
			}
		}
	assassin{
		name="Ninja"
		description={""}
		tier = 3

		level_knight = 1
		level_rogue  = 2
		icon = 'assassin.dmi'
		max_health = 8
		speed = 2
		max_aura = 4
		aura_rate = 75
		projectile_type = /game/hero/projectile/black_sword
		skill1_cost = 1
		skill2_cost = 2
		skill3_cost = 4
		skill1 = /game/hero/skill/ninja_star
		skill2 = /game/hero/skill/bomb
		skill3 = /game/hero/skill/ninja_mode
		take_turn(){
			if(disappeared > 0){
				disappeared--
				invulnerable = 2
				if(!disappeared){
					invincible = FALSE
					trapable = TRUE
					disappeared = FALSE
					aura = 0
					adjust_aura(0)
					}
				}
			. = ..()
			}
		shoot(){
			. = ..()
			if(disappeared){
				invincible = FALSE
				trapable = TRUE
				disappeared = FALSE
				invisibility = 0
				aura = 0
				adjust_aura(0)
				return
				}
			}
		}
	gypsy{
		name="Gypsy"
		description={""}
		tier = 3

		level_priest = 1
		level_rogue  = 2
		icon = 'gypsy.dmi'
		max_health = 6
		max_aura = 4
		speed = 2
		aura_rate = 175
		projectile_type = /game/hero/projectile/note
		skill1_cost = 3
		skill2_cost = 4
		skill1 = /game/hero/skill/protect
		skill2 = /game/hero/skill/slow
		skill3 = /game/hero/skill/proj_wood_sword
		}
	vampire{
		name="Vampire"
		description={"<b>Notes:</b> While the Vampire is transformed he appears as a bat that can move over any terrain, and attacks with a Fire Blast. Maintaining the transformation drains the Vampires aura, and he reverts to his original form once the aura is depleted."}
		tier = 3

		level_mage   = 1
		level_rogue  = 2
		icon = 'dracula.dmi'
		projectile_type = /game/hero/projectile/wood_sword
		skill1_cost = 0
		skill1 = /game/hero/skill/bat_change
		max_aura = 256
		aura_rate = 1
		max_health = 8
		adjust_aura(amo){
			if(bat){
				if(amo > 0){ return}
				else{
					. = ..()
					if(aura <= 0){
						bat = FALSE
						projectile_type = initial(projectile_type)
						icon_state = null
						height = initial(height)
						movement = MOVEMENT_LAND
						speed = initial(speed)
						}
					}
				return
				}
			. = ..()
			}
		take_turn(){
			. = ..()
			if(bat){
				adjust_aura(-pick(1,2))
				}
			}
		}
	rogue{
		name="Rogue"
		description={""}
		tier = 3

		level_rogue  = 3
		icon = 'rogue.dmi'
		max_health = 8
		max_aura = 4
		speed = 3
		aura_rate = 100
		projectile_type = /game/hero/projectile/arrow
		skill1_cost = 1
		skill2_cost = 2
		skill3_cost = 4
		skill1 = /game/hero/skill/triple_arrow
		skill2 = /game/hero/skill/rogue_mode
		skill3 = /game/hero/skill/flame_arrow
		}
	rebel{
		name="Revolutionary"
		description={""}
		tier = 4

		level_knight= 1
		level_priest= 1
		level_mage  = 1
		level_rogue = 1
		icon = 'rebel.dmi'
		max_health = 8
		max_aura = 3
		speed = 2
		front_protection = TRUE
		projectile_type = /game/hero/projectile/wood_lance
		skill1_cost = 1
		skill2_cost = 3
		skill1 = /game/hero/skill/heal_cherry
		skill2 = /game/hero/skill/rebel_star

		fighter{
			name="Fighter"
			description={""}

			parent_type = /game/hero
			icon = 'rebel_turn_shield.dmi'
			max_health = 8
			max_aura = 0
			projectile_type = /game/hero/projectile/sword
			front_protection = TRUE
			}
		healer{
			name="Healer"
			description={""}

			parent_type = /game/hero
			icon = 'rebel_turn.dmi'
			max_health = 6
			max_aura = 3
			skill1_cost = 1
			skill1 = /game/hero/skill/heal_cherry
			}
		magician{
			name="Magician"
			description={""}

			parent_type = /game/hero
			icon = 'rebel_turn.dmi'
			max_health = 6
			max_aura = 5
			aura_rate = 75
			projectile_type = /game/hero/projectile/wood_sword
			skill1_cost = 1
			skill2_cost = 2
			skill1 = /game/hero/skill/magic1
			skill2 = /game/hero/skill/magic2
			}
		anarchist{
			name="Anarchist"
			description={""}

			parent_type = /game/hero
			icon = 'rebel_turn.dmi'
			max_health = 4
			max_aura = 0
			speed = 2
			projectile_type = /game/hero/projectile/arrow
			skill1 = /game/hero/skill/proj_wood_sword
			skill2 = /game/hero/skill/proj_wood_sword
			skill3 = /game/hero/skill/proj_wood_sword
			}
		}
	gnome{
		name="Gnome"
		description={""}
		tier = 3

		icon = 'gnome_red.dmi'
		red{
			level_knight = 1
			level_priest = 1
			level_rogue = 1
			icon = 'gnome_red.dmi'
			}
		blue{
			level_knight = 1
			level_mage = 1
			level_priest = 1
			icon = 'gnome_blue.dmi'
			}
		aura_rate = 100
		max_health = 20
		max_aura = 2
		speed = 2
		x_offset = -3
		width = 10
		height = 10
		projectile_type = /game/hero/gnome/fist
		skill2_cost = 1
		skill1 = /game/hero/skill/radish1
		skill2 = /game/hero/skill/heal_radish
		stun{
			parent_type = /game/map/mover/intelligence
			var{
				time = 0
				radishes = TRUE
				}
			New(var/_time = 0){
				time = _time
				}
			intelligence(var/game/hero/gnome/mover){
				mover.icon_state = "stun"
				mover.invulnerable = 3
				if(radishes){
					radishes = FALSE
					for(var/I = 1 to pick(3,4)){
						new /game/hero/gnome/radish_2(mover)
						}
					}
				if(time-- <= 0){
					mover.icon_state = initial(mover.icon_state)
					mover.invulnerable = 32
					Del()
					}
				}
			}
		fist{
			parent_type = /game/hero/projectile/fist
			icon_state = "fist"
			height = 8
			width  = 8
			persistent = TRUE
			potency = 2
			max_time = 5
			speed = 4
			behavior(){
				for(var/game/hero/gnome/H){
					if(H == owner){ continue}
					if(H.invulnerable){ continue}
					if(collision_check(H)){
						H.intelligence = new /game/hero/gnome/stun(50)
						}
					}
				. = ..()
				}
			}
		radish_1{
			parent_type = /game/hero/projectile/magic_1
			movement = MOVEMENT_ALL
			icon = 'gnome_enemies.dmi'
			icon_state = "radish"
			height = 4
			width = 4
			y_offset = -1
			potency = 2
			max_range = 96
			}
		radish_2{
			parent_type = /game/item/cherry
			icon = 'gnome_enemies.dmi'
			icon_state = "radish"
			lifespan = 60
			var{
				speed = 3
				theta
				}
			New(){
				. = ..()
				theta = rand(1,360)
				}
			behavior(){
				. = ..()
				if(speed > 0){
					translate(cos(theta)*speed,sin(theta)*speed)
					speed -= 0.3
					}
				}
			activate(){
				if(speed > 0){ return}
				. = ..()
				}
			potency = 3
			}
		}
	}