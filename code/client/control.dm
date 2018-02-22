

//-- Hero Control --------------------------------------------------------------

client
	var/game/hero/hero
	proc
		intelligence(var/game/map/mover/M)
			if(!hero.projectile)
				var/x_translate = 0
				var/y_translate = 0
				var/_check = key_state | key_pressed
				//if(    (EAST  & _check) && (SHIFT & _check)){ hero.dir = EAST }
				if(EAST  & _check) x_translate += hero.speed
				//if(    (WEST  & _check) && (SHIFT & _check)){ hero.dir = WEST }
				if(WEST  & _check) x_translate -= hero.speed
				//if(    (NORTH & _check) && (SHIFT & _check)){ hero.dir = NORTH}
				if(NORTH & _check) y_translate += hero.speed
				//if(    (SOUTH & _check) && (SHIFT & _check)){ hero.dir = SOUTH}
				if(SOUTH & _check) y_translate -= hero.speed
				M.px_move(x_translate, y_translate)
				if(PRIMARY & key_pressed)
					hero.shoot()
				else if(SECONDARY & key_pressed && (hero.skill1))
					if(hero.aura >= hero.skill1_cost)
						hero.adjust_aura(-hero.skill1_cost)
						var/game/hero/skill/skill1 = new hero.skill1(hero)
						skill1.activate()
				else if(TERTIARY & key_pressed && (hero.skill2))
					if(hero.aura >= hero.skill2_cost)
						hero.adjust_aura(-hero.skill2_cost)
						var/game/hero/skill/skill2 = new hero.skill2(hero)
						skill2.activate()
				else if(QUATERNARY & key_pressed && (hero.skill3))
					if(hero.aura >= hero.skill3_cost)
						hero.adjust_aura(-hero.skill3_cost)
						var/game/hero/skill/skill3 = new hero.skill3(hero)
						skill3.activate()
				else if(HELP_KEY & key_pressed)
					hero.call_help()
			clear_keys()
