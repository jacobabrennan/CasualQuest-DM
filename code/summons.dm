

//-- Summons -------------------------------------------------------------------

game/hero
	summon
		icon = 'summons.dmi'
		tombing = FALSE
		scoring = FALSE
		var
			game/hero/owner

		New(var/game/hero/_owner)
			. = ..()
			owner = _owner
			c = owner.c.Copy()
			invulnerable = INVULNERABLE_TIME

		take_turn()
			if(!player)
				if(!owner)
					die()
				if(game.stage != STAGE_PLAY)
					die()
			. = ..()

game/hero/summon/archetype
	normal
		var
			bearing = 0
			shoot_frequency = 96
			move_toggle = -1
			atomic = TRUE
		New()
			. = ..()
			bearing = pick(0, 90, 180, 270)

		behavior()
			. = ..()
			if(move_toggle == 1)
				move_toggle = FALSE
				return
			else if(!move_toggle)
				move_toggle = TRUE
			if(projectile_type)
				if(rand()*shoot_frequency > shoot_frequency-1)
					shoot()
			if((!(c.x%TILE_WIDTH) && !(c.y%TILE_HEIGHT)) && rand()*4 > 3)
				bearing += pick(90, -90)
			else if(!atomic && rand()*32 > 31)
				bearing += pick(90, -90)
			if(bearing <    0) bearing += 360
			if(bearing >= 360) bearing -= 360
			var/x_trans = 0
			var/y_trans = 0
			switch(bearing)
				if(  0)
					x_trans = speed
				if( 90)
					y_trans = speed
				if(180)
					x_trans = -speed
				if(270)
					y_trans = -speed
			px_move(x_trans, y_trans)

		horizontal_stop()
			bearing += pick(90, -90, 180)

		vertical_stop()
			bearing += pick(90, -90, 180)

		hurt(damage, var/game/map/mover/combatant/attacker, var/game/map/mover/projectile/proxy)
			if(!proxy)
				bearing -= 180
			. = ..()

		proc
			atom_cross()
				if(rand()*4 > 3)
					bearing += pick(90, -90, 180)
