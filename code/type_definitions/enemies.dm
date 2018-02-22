

//-- Enemy Type Defs -----------------------------------------------------------

game/enemy{
	var{
		speed = 1
		bearing = 0
		touch_damage = 1
		undead = FALSE
		demon = FALSE
		hurt_sound = "small_hurt"
		}
	bug{
		parent_type = /game/enemy/archetype/normal
		move_toggle = TRUE
		_1{
			icon_state = "bug_1"
			max_health = 1
			touch_damage = 1
			score = 1
			}
		_2{
			icon_state = "bug_2"
			max_health = 2
			touch_damage = 1
			score = 5
			}
		_3{
			icon_state = "bug_3"
			max_health = 4
			touch_damage = 2
			score = 10
			}
		}
	boar{
		parent_type = /game/enemy/archetype/normal
		projectile_type = /game/map/mover/projectile/spear
		_1{
			icon_state = "boar_1"
			max_health = 2
			touch_damage = 1
			score = 3
			}
		_2{
			icon_state = "boar_2"
			max_health = 3
			touch_damage = 1
			score = 10
			}
		_3{
			icon_state = "boar_3"
			max_health = 4
			touch_damage = 2
			score = 20
			}
		}
	bird{
		parent_type = /game/enemy/archetype/diagonal
		icon_state = "parrot"
		speed = 2
		_1{
			icon_state = "parrot_1"
			speed = 1
			max_health = 1
			touch_damage = 1
			score = 5
			}
		_2{
			icon_state = "parrot_2"
			max_health = 2
			touch_damage = 1
			score = 15
			}
		_3{
			icon_state = "parrot_3"
			max_health = 3
			touch_damage = 2
			score = 30
			}
		}
	knight{
		parent_type = /game/enemy/archetype/normal
		front_protection = TRUE
		_1{
			icon_state = "knight_1"
			max_health = 3
			touch_damage = 1
			score = 10
			}
		_2{
			icon_state = "knight_2"
			max_health = 5
			touch_damage = 2
			score = 23
			}
		_3{
			icon_state = "knight_3"
			max_health = 8
			touch_damage = 3
			score = 40
			}
		}
	turtle{
		parent_type = /game/enemy/archetype/normal
		move_toggle = -1
		speed = 1
		bearing = 180
		var{
			hiding = FALSE
			}
		hurt(amount,attacker,proxy){
			if(hiding){
				game.audio.play_sound("defend")
				return
				}
			. = ..()
			}
		behavior(){
			var/game/hero/H = locate() in range(COLLISION_RANGE, src)
			if(H){
				if(hiding){
					new /game/map/mover/projectile/bomb(src)
					hiding = FALSE
					icon_state = initial(icon_state)
					}
				else if(rand()*shoot_frequency > shoot_frequency-1){
					new /game/map/mover/projectile/bomb(src)
					}
				var/gap_x = (c.x+(width /2)) - (H.c.x+(H.width /2))
				var/gap_y = (c.y+(height/2)) - (H.c.y+(H.height/2))
				if(abs(gap_x) <= abs(gap_y)){
					if(gap_x > 0){ dir = NORTH}
					else{ dir = SOUTH}
					}
				else{
					if(gap_y > 0){ dir = NORTH}
					else{ dir = SOUTH}
					}
				. = ..()
				}
			else{
				if(!hiding){
					if(rand()*32 > 31){
						hiding = TRUE
						icon_state = "[icon_state]_defended"
						}
					else{
						. = ..()
						}
					}
				}
			}
		_1{
			icon_state = "turtle_1"
			max_health = 2
			touch_damage = 1
			shoot_frequency = 128
			score = 10
			}
		_2{
			icon_state = "turtle_2"
			max_health = 3
			touch_damage = 1
			shoot_frequency = 96
			score = 20
			}
		_3{
			icon_state = "turtle_3"
			max_health = 3
			speed = 2
			touch_damage = 2
			shoot_frequency = 64
			score = 30
			}
		}
	bat{
		parent_type = /game/enemy/archetype/normal
		icon_state = "bat"
		movement = MOVEMENT_ALL
		move_toggle = -1
		speed = 1
		height = 9
		var{
			pausing = 0
			}
		behavior(){
			if(pausing){
				pausing--
				return
				}
			else{
				if(rand()*128 > 127){
					pausing = INVULNERABLE_TIME*3
					}
				. = ..()
				}
			}
		_1{
			icon_state = "bat_1"
			max_health = 1
			touch_damage = 1
			score = 3
			}
		_2{
			icon_state = "bat_2"
			max_health = 2
			touch_damage = 1
			score = 10
			}
		_3{
			icon_state = "bat_3"
			move_toggle = 0
			speed = 3
			//projectile_type = /game/map/mover/projectile/fire_1
			max_health = 2
			touch_damage = 1
			score = 20
			}
		}
	snake{
		parent_type = /game/enemy/archetype/normal
		icon_state = "snake"
		speed = 1
		var{
			pausing = 0
			}
		behavior(){
			if(pausing){
				pausing--
				if(pausing == 0){
					var/game/hero/H = pick(game.heros)
					dir = dir_to(H)
					}
				return
				}
			else{
				if(rand()*128 > 127){
					pausing = INVULNERABLE_TIME*3
					}
				. = ..()
				}
			}
		_1{
			icon_state = "snake_1"
			max_health = 1
			touch_damage = 1
			score = 3
			}
		_2{
			icon_state = "snake_2"
			max_health = 2
			touch_damage = 1
			move_toggle = -1
			score = 10
			}
		_3{
			icon_state = "snake_3"
			speed = 3
			max_health = 2
			touch_damage = 1
			score = 20
			}
		}
	vampire{
		parent_type = /game/enemy/archetype/normal
		icon_state = "vampire"
		undead = TRUE
		var{
			batty
			state_level = 1
			pausing = 0
			}
		behavior(){
			if(     y == world.maxy){ bearing = 270}
			else if(y == 1         ){ bearing =  90}
			else if(x == world.maxx){ bearing = 180}
			else if(x == 1         ){ bearing =   0}
			if(batty){
				if(rand()*96 > 95){
					var/game/map/tile/T = loc
					if(!(T.movement & (MOVEMENT_WALL|MOVEMENT_WATER))){
						batty = FALSE
						move_toggle = TRUE
						movement = MOVEMENT_LAND
						icon_state = "vampire_[state_level]"
						projectile_type = initial(projectile_type)
						height = 16
						. = ..()
						}
					else{
						. = ..()
						}
					}
				else{
					if(pausing){
						pausing--
						return
						}
					else{
						if(rand()*128 > 127){
							pausing = INVULNERABLE_TIME
							}
						. = ..()
						}
					}
				}
			else{
				if(rand()*128 > 127){
					batty = TRUE
					move_toggle = -1
					movement = MOVEMENT_ALL
					projectile_type = null
					icon_state = "bat_[state_level]"
					height = 9
					c.y += 7
					. = ..()
					}
				else{
					. = ..()
					}
				}
			}
		_1{
			icon_state = "vampire_1"
			max_health = 2
			touch_damage = 2
			state_level = 1
			score = 10
			}
		_2{
			icon_state = "vampire_2"
			max_health = 3
			touch_damage = 3
			state_level = 2
			score = 20
			}
		_3{
			icon_state = "vampire_3"
			projectile_type = /game/map/mover/projectile/fire_1
			max_health = 4
			touch_damage = 4
			state_level = 3
			score = 40
			}
		}
	ghost{
		parent_type = /game/enemy/archetype/diagonal
		px_move(amo_x, amo_y, unused){
			. = ..(amo_x, amo_y, dir)
			}
		icon_state = "ghost"
		speed = 1
		undead = TRUE
		_1{
			icon_state = "ghost_1"
			max_health = 2
			touch_damage = 1
			score = 5
			}
		_2{
			icon_state = "ghost_2"
			max_health = 3
			touch_damage = 1
			score = 15
			}
		_3{
			icon_state = "ghost_3"
			max_health = 4
			touch_damage = 2
			score = 30
			}
		}
	skull{
		parent_type = /game/enemy/archetype/normal
		icon_state = "skull"
		undead = TRUE
		movement = MOVEMENT_ALL
		width = 12
		height = 15
		projectile_type = /game/map/mover/projectile/bone
		_1{
			icon_state = "skull_1"
			projectile_type = null
			max_health = 1
			touch_damage = 1
			score = 3
			}
		_2{
			icon_state = "skull_2"
			max_health = 1
			touch_damage = 1
			score = 10
			}
		_3{
			icon_state = "skull_3"
			max_health = 2
			touch_damage = 1
			score = 20
			}
		}
	imp{
		parent_type = /game/enemy/archetype/normal
		demon = TRUE
		_1{
			icon_state = "imp_1"
			projectile_type = null
			max_health = 1
			touch_damage = 1
			score = 2
			}
		_2{
			icon_state = "imp_2"
			projectile_type = /game/map/mover/projectile/fire_1
			max_health = 2
			touch_damage = 1
			score = 15
			}
		_3{
			icon_state = "imp_3"
			projectile_type = /game/map/mover/projectile/fire_2
			max_health = 4
			touch_damage = 2
			score = 30
			}
		}
	mummy{
		parent_type = /game/enemy/archetype/normal
		icon_state = "mummy"
		undead = TRUE
		var{
			crazy
			}
		behavior(){
			if(crazy){
				crazy--
				if(!crazy){
					speed = initial(speed)
					move_toggle = TRUE
					}
				if(rand()*4 > 3){
					bearing = pick(0,90,180,270)
					}
				. = ..()
				return
				}
			else{
				if(rand()*128 > 127){
					invulnerable = 10
					crazy = INVULNERABLE_TIME
					move_toggle = FALSE
					speed = 2
					}
				. = ..()
				}
			}
		_1{
			icon_state = "mummy_1"
			projectile_type = null
			max_health = 3
			touch_damage = 1
			score = 10
			}
		_2{
			icon_state = "mummy_2"
			projectile_type = null
			max_health = 5
			touch_damage = 2
			score = 23
			}
		_3{
			icon_state = "mummy_3"
			projectile_type = null
			max_health = 7
			touch_damage = 3
			score = 40
			}
		}
	scuzzy{
		parent_type = /game/enemy/archetype/normal
		icon_state = "scuzzy"
		projectile_type = /game/map/mover/projectile/acid
		shoot_frequency = 32
		shoot(){
			. = ..()
			bearing += 180
			if(     bearing <    0){ bearing += 360}
			else if(bearing >= 360){ bearing -= 360}
			if(projectiles.len >= 3){
				var/game/map/mover/projectile/P = projectiles[1]
				projectiles.Remove(P)
				P.Del()
				}
			}
		_1{
			icon_state = "scuzzy_1"
			max_health = 1
			touch_damage = 1
			score = 3
			}
		_2{
			icon_state = "scuzzy_2"
			max_health = 2
			touch_damage = 1
			score = 10
			}
		_3{
			icon_state = "scuzzy_3"
			max_health = 3
			touch_damage = 1
			score = 20
			}
		}
	spider{
		parent_type = /game/enemy/archetype/normal
		projectile_type = /game/map/mover/projectile/silk_small
		shoot_frequency = 64
		var{
			coord/target
			target_time = 96
			}
		behavior(){
			if(!target){
				return ..()
				}
			else{
				target_time--
				speed = 2
				if(target_time <= 0){
					del target
					speed = initial(speed)
					return ..()
					}
				var/trans_x = 0 //sign(target.x - (c.x + width /2))
				var/trans_y = 0 //sign(target.y - (c.y + height/2))
				if(target.x){
					trans_x = sign(target.x - (c.x + width /2))
					}
				if(target.y){
					trans_y = sign(target.y - (c.y + height/2))
					}
				px_move(trans_x, trans_y)
				}
			}
		shoot(){
			if(projectiles.len >= 5){
				var/first = projectiles[1]
				projectiles.Remove(first)
				del first
				}
			dir = turn(dir, 180)
			. = ..()
			dir = turn(dir, 180)
			}
		_1{
			icon_state = "spider_1"
			max_health = 4
			touch_damage = 1
			}
		_2{
			icon_state = "spider_2"
			max_health = 6
			touch_damage = 2
			shoot_frequency = 48
			}
		_3{
			icon_state = "spider_3"
			max_health = 8
			move_toggle = -1
			touch_damage = 2
			shoot_frequency = 32
			}
		}
	eye{
		parent_type = /game/enemy/archetype/ball/group_member
		move_toggle = -1
		score = 0
		_1{
			icon_state = "eye_1"
			max_health = 2
			touch_damage = 1
			}
		_2{
			icon_state = "eye_2"
			max_health = 3
			touch_damage = 1
			}
		_3{
			icon_state = "eye_3"
			max_health = 5
			touch_damage = 2
			}
		}
	genie{
		parent_type = /game/enemy/archetype/normal
		demon = TRUE
		icon_state = "genie"
		projectile_type = /game/map/mover/projectile/seeker_1
		_1{
			icon_state = "genie_1"
			max_health = 3
			touch_damage = 1
			score = 10
			}
		_2{
			icon_state = "genie_2"
			max_health = 4
			touch_damage = 2
			score = 20
			}
		_3{
			icon_state = "genie_3"
			max_health = 5
			touch_damage = 2
			projectile_type = /game/map/mover/projectile/seeker_2
			score = 35
			}
		}
	wizard{
		parent_type = /game/enemy/archetype/normal
		touch_damage = 0
		icon_state = "wizard_1"
		projectile_type = /game/map/mover/projectile/magic_1
		var{
			_appearance = 0
			last_shoot = 128
			}
		New(){
			. = ..()
			touch_damage = 0
			icon_state = "blank"
			}
		hurt(){
			if(icon_state == "wizard_flash"){ return}
			. = ..()
			}
		behavior(){
			if(_appearance){
				_appearance--
				if(_appearance == 96){
					icon_state = initial(icon_state)
					touch_damage = initial(touch_damage)
					new projectile_type(src)
					}
				if(!_appearance){
					for(var/game/map/mover/projectile/sand_trap/S in projectiles){
						del S
						}
					c.x = 1
					c.y = 1
					redraw()
					icon_state = "blank"
					touch_damage = 0
					last_shoot = initial(last_shoot)+rand(-12,12)
					}
				return
				}
			else{
				last_shoot--
				if(last_shoot <= 0){
					var/game/hero/H = pick(game.heros)
					c.x = rand(1,world.maxx-2) * TILE_WIDTH
					c.y = rand(1,world.maxy-2) * TILE_HEIGHT
					redraw()
					if(abs(H.x - x) > abs(H.y - y)){
						if(H.x > x){ dir = EAST }
						else{        dir = WEST }
						}
					else{
						if(H.y > y){ dir = NORTH}
						else{        dir = SOUTH}
						}
					_appearance = 128
					touch_damage = 0
					icon_state = "wizard_flash"
					}
				}
			}
		_1{
			icon_state = "wizard_1"
			max_health = 1
			touch_damage = 1
			score = 5
			}
		_2{
			icon_state = "wizard_2"
			max_health = 1
			touch_damage = 1
			projectile_type = /game/map/mover/projectile/magic_2
			score = 13
			}
		_3{
			icon_state = "wizard_3"
			max_health = 2
			touch_damage = 1
			projectile_type = /game/map/mover/projectile/magic_2
			score = 28
			}
		}
	digger{
		touch_damage = 0
		icon_state = "digger_1"
		height = 8
		width = 8
		var{
			_appearance = 0
			last_shoot = 128
			}
		New(){
			. = ..()
			touch_damage = 0
			icon_state = "blank"
			}
		hurt(){
			if(icon_state == "digger_hidden"){ return}
			. = ..()
			}
		translate(){
			if(_appearance){ return}
			. = ..()
			}
		behavior(){
			if(_appearance){
				_appearance--
				if(_appearance == 96){
					icon_state = initial(icon_state)
					touch_damage = initial(touch_damage)
					new /game/map/mover/projectile/sand_trap(src)
					}
				if(!_appearance){
					for(var/game/map/mover/projectile/sand_trap/S in projectiles){
						del S
						}
					c.x = 1
					c.y = 1
					redraw()
					icon_state = "blank"
					touch_damage = 0
					last_shoot = initial(last_shoot)+rand(-12,12)
					}
				return
				}
			else{
				last_shoot--
				if(last_shoot <= 0){
					c.x = rand(1,world.maxx-2) * TILE_WIDTH    + (TILE_WIDTH -width )/2
					c.y = rand(1,world.maxy-2) * TILE_HEIGHT   + (TILE_HEIGHT-height)/2
					redraw()
					_appearance = 128
					icon_state = "digger_hidden"
					}
				}
			}
		_1{
			icon_state = "digger_1"
			max_health = 1
			touch_damage = 1
			score = 5
			}
		_2{
			icon_state = "digger_2"
			max_health = 3
			touch_damage = 2
			score = 13
			}
		_3{
			icon_state = "digger_3"
			max_health = 5
			touch_damage = 2
			score = 28
			}
		}/*
	shield{
		var{
			steps = 4
			defending = 128
			level = 1
			}
		behavior(){
			if(defending){
				defending--
				if(defending <= 0){

					}
				}
			. = ..()
			}
		atom_cross(){
			steps--
			if(!steps){

				}
			}
		}*/
	archetype{
		normal{
			var{
				projectile_type
				shoot_frequency = 96
				move_toggle
				atomic
				}
			New(){
				. = ..()
				bearing = pick(0, 90, 180, 270)
				}
			behavior(){
				//bearing += rand(-10,10)
				. = ..()
				if(move_toggle == 1){
					move_toggle = FALSE
					return
					}
				else if(!move_toggle){
					move_toggle = TRUE
					}
				if(projectile_type){
					if(rand()*shoot_frequency > shoot_frequency-1){
						shoot()
						}
					}
				if((!(c.x%TILE_WIDTH) && !(c.y%TILE_HEIGHT)) && rand()*4 > 3){
					bearing += pick(90, -90)
					}
				else if(!atomic && rand()*32 > 31){
					bearing += pick(90, -90)
					}
				if(bearing <    0){ bearing += 360}
				if(bearing >= 360){ bearing -= 360}
				var/x_trans = 0
				var/y_trans = 0
				switch(bearing){
					if(  0){
						x_trans = speed
						}
					if( 90){
						y_trans = speed
						}
					if(180){
						x_trans = -speed
						}
					if(270){
						y_trans = -speed
						}
					}
				px_move(x_trans, y_trans)
				}
			horizontal_stop(){
				bearing += pick(90, -90, 180)
				}
			vertical_stop(){
				bearing += pick(90, -90, 180)
				}
			proc{
				atom_cross(){
					if(rand()*4 > 3){
						bearing += pick(90, -90, 180)
						}
					}
				shoot(){
					new projectile_type(src)
					}
				}
			}
		diagonal{
			movement = MOVEMENT_ALL
			New(){
				. = ..()
				bearing = pick(45, 135, 225, 315)
				}
			horizontal_stop(){
				switch(bearing){
					if( 45){ bearing = 135}
					if(135){ bearing =  45}
					if(225){ bearing = 315}
					if(315){ bearing = 225}
					}
				}
			vertical_stop(){
				switch(bearing){
					if( 45){ bearing = 315}
					if(135){ bearing = 225}
					if(225){ bearing = 135}
					if(315){ bearing =  45}
					}
				}
			behavior(){
				//bearing += rand(-10,10)
				. = ..()
				var/x_trans = 0
				var/y_trans = 0
				switch(bearing){
					if( 45){
						dir = NORTHEAST
						x_trans =  speed
						y_trans =  speed
						}
					if(135){
						dir = NORTHWEST
						x_trans = -speed
						y_trans =  speed
						}
					if(225){
						dir = SOUTHWEST
						x_trans = -speed
						y_trans = -speed
						}
					if(315){
						dir = SOUTHEAST
						x_trans =  speed
						y_trans = -speed
						}
					}
				px_move(x_trans, y_trans)
				}
			}
		snaking{
			parent_type = /game/enemy/archetype/normal
			atomic = TRUE
			var{
				list/body = new()
				length = 4
				body_radius = 8
				list/old_positions
				body_health = 1
				body_state
				tail_state
				body_invulnerable = TRUE
				}
			speed = 1
			New(){
				. = ..()
				max_health = body_health * length + max_health
				health = max_health
				layer++
				old_positions = new()
				var/game/enemy/lead = src
				for(var/I = 1 to length){
					var/game/enemy/archetype/snaking/body/B = new()
					B.c.x = c.x+(width -B.width )/2
					B.c.y = c.y+(height-B.height)/2
					body.Add(B)
					if(lead != src){
						var/game/enemy/archetype/snaking/body/leader = lead
						leader.follower = B
						}
					B.lead = lead
					lead = B
					B.head = src
					if(I == length && tail_state){
						B.icon_state = tail_state
						}
					else{
						B.icon_state = body_state
						}
					B.height = body_radius
					B.width = body_radius
					}
				}
			behavior(){
				var/coord/old_c = c.Copy()
				old_c.x += (width -body_radius)/2
				old_c.y += (height-body_radius)/2
				old_positions.Insert(1, old_c)
				old_positions[old_c] = dir
				. = ..()
				for(var/I = 1 to body.len){
					var/old_index
					if(move_toggle == -1){
						old_index = round(I * body_radius/speed)
						}
					else{
						old_index = round(I * body_radius*2/speed)
						}
					if(old_index <= old_positions.len){
						var/game/enemy/archetype/snaking/body/B = body[I]
						if(!B){ continue}
						var/coord/new_c = old_positions[old_index]
						B.dir = old_positions[new_c]
						B.c.x = new_c.x
						B.c.y = new_c.y
						}
					}
				if(move_toggle == -1){
					old_positions.len = min(old_positions.len, round(body.len*body_radius/speed))
					}
				else{
					old_positions.len = min(old_positions.len, round(body.len*body_radius*2/speed))
					}
				}
			hurt(amount, attacker, proxy){
				if(istype(attacker, /game/hero/projectile/bomb)){
					invulnerable = 0
					. = ..()
					}
				else{
					. = ..()
					}
				if(body.len){
					for(var/I = body.len to 1 step -1){
						if(I > body.len){ continue}
						var/game/enemy/E = body[I]
						if(!E){ continue}
						E.invulnerable = invulnerable
						if((I * body_health)+initial(max_health) > health){
							E.die()
							if(tail_state && body.len){
								var/game/enemy/EE = body[body.len]
								EE.icon_state = tail_state
								}
							}
						}
					}
				}
			die(){
				for(var/game/enemy/E in body){
					E.die()
					}
				. = ..()
				}
			Del(){
				for(var/game/enemy/E in body){
					del E
					}
				. = ..()
				}
			body{
				parent_type = /game/enemy
				movement = MOVEMENT_ALL
				var{
					game/enemy/archetype/snaking/head
					game/enemy/lead
					game/enemy/follower
					}
				hurt(amount, attacker, proxy){
					if(head.body_invulnerable){
						game.audio.play_sound("defend")
						}
					else{
						head.hurt(amount)
						}
					}
				die(){
					head.body.Remove(src)
					. ..()
					}
				}
			}
		ball{
			parent_type = /game/enemy/archetype/normal
			width = 24
			height = 24
			var{
				list/group = new() // May contain coord objects!
				group_size = 2
				child_type = /game/enemy
				child_diameter = 16
				child_distance = 4
				respawn_time = 128
				}
			New(){
				. = ..()
				layer++
				spawn(){
					var/coord/center = coord(c.x + width/2, c.y + height/2)
					for(var/I = 1 to group_size){
						var/coord/angle
						if(group_size <= 6 || I <= 6){
							angle = round(((I-1)*(360/min(group_size,6))))
							angle = coord(
								cos(angle)*((width/2)+child_distance),
								sin(angle)*((width/2)+child_distance),
								)
							}
						else{
							angle = round(((I-1)*(360/(group_size-6))))
							angle = coord(
								cos(angle)*((width/2)+(child_diameter)),
								sin(angle)*((width/2)+(child_diameter)),
								)
							}
						var/game/enemy/archetype/ball/group_member/M = new child_type()
						M.leader = src
						M.leader_offset = angle
						M.c.x = center.x + angle.x
						M.c.y = center.y + angle.y
						if(M.c.x < 0 || M.c.x > world.maxx*TILE_WIDTH ){ M.c.x = M.leader.c.x}
						if(M.c.y < 0 || M.c.y > world.maxx*TILE_HEIGHT){ M.c.y = M.leader.c.y}
						group.Add(M)
						}
					}
				}
			behavior(){
				. = ..()
				if(rand()*respawn_time > respawn_time-1){
					var/coord/empty_slot = locate() in group
					if(empty_slot){
						var/coord/center = coord(c.x + width/2, c.y + height/2)
						var/group_index = group.Find(empty_slot)
						var/game/enemy/archetype/ball/group_member/M = new child_type()
						M.leader = src
						M.leader_offset = empty_slot
						M.c.x = center.x
						M.c.y = center.y
						group[group_index] = M
						}
					}
				if(rand()*respawn_time*3 > (respawn_time*3)-1){
					var/game/enemy/archetype/ball/group_member/M = pick(group)
					if(istype(M)){
						var/group_index = group.Find(M)
						group[group_index] = M.leader_offset
						M.leader = null
						M.leader_offset = null
						}
					}
				}
			die(){
				for(var/I = group.len to 1 step-1){
					var/game/enemy/E = group[I]
					if(!istype(E)){ continue}
					health = E.health
					E.die()
					return
					}
				. = ..()
				}
			Del(){
				for(var/datum/D in group){
					del D
					}
				. = ..()
				}
			group_member{
				parent_type = /game/enemy/archetype/normal
				movement = MOVEMENT_ALL
				move_toggle = -1
				var{
					game/enemy/archetype/ball/leader
					coord/leader_offset
					}
				behavior(){
					if(leader){
						var/coord/leader_center = coord(leader.c.x+(leader.width/2), leader.c.y+(leader.height/2))
						leader_center.x = (leader_center.x-leader_offset.x) - (width /2)
						leader_center.y = (leader_center.y-leader_offset.y) - (height/2)
						var/gap_x = max(-speed, min(speed, leader_center.x - c.x))
						var/gap_y = max(-speed, min(speed, leader_center.y - c.y))
						px_move(gap_x, gap_y, dir)
						if(rand()*32 > 31){
							dir = pick(NORTH, SOUTH, EAST, WEST)
							}
						if(rand()*128 > 127){
							var/game/enemy/archetype/ball/group_member/E
							E = leader.group[rand(1,min(6,leader.group.len))]
							if(!istype(E)){
								var/coord/angle = E
								if(!istype(angle)){ return}
								var/group_index = leader.group.Find(angle)
								leader.group[group_index] = leader_offset
								leader_offset = angle
								}
							else{
								var/coord/new_angle = E.leader_offset
								E.leader_offset = leader_offset
								leader_offset = new_angle
								}
							}
						}
					else{
						. = ..()
						}
					}
				die(){
					if(leader && (src in leader.group)){
						var/group_index = leader.group.Find(src)
						leader.group[group_index] = leader_offset
						}
					. = ..()
					}
				hurt(amount, attacker, proxy){
					if(leader && !invulnerable){
						leader.invulnerable = max(INVULNERABLE_TIME, leader.invulnerable)
						//hurt(0, attacker, proxy)
						}
					. = ..()
					}
				}
			}
		}
	}
game/enemy{
	blob{
		parent_type = /game/enemy/archetype/normal
		projectile_type = /game/enemy/blob/jump_shadow
		shoot_frequency = 64
		icon = 'large.dmi'
		icon_state = "blob_1_front"
		movement = MOVEMENT_LAND
		width = 30
		height = 30
		x_offset = -1
		y_offset = -1
		var{
			level = 1
			game/map/mover/combatant/hostage
			jump_shadow
			}
		New(){
			. = ..()
			layer++
			underlays.Add(image(icon, src, "blob_[level]_back", layer-2))
			}
		Del(){
			del jump_shadow
			for(var/game/map/mover/M in projectiles){
				M.Del()
				}
			. = ..()
			}
		attack(var/game/hero/target, amount, var/game/map/mover/projectile/proxy){
			var/game/enemy/blob/jump_shadow/shadow = intelligence
			if(istype(shadow)){
				return
				}
			if(target == hostage){ return}
			. = ..()
			if(proxy){ return}
			if(!hostage && target.trapable){
				hostage = target
				hostage.c.x = c.x + (width -hostage.width )/2
				hostage.c.y = c.y + (height-hostage.height)/2
				}
			}
		behavior(){
			. = ..()
			if(hostage){
				if(!collision_check(hostage)){ hostage = null}
				else{
					hostage.c.x = c.x + (width -hostage.width )/2
					hostage.c.y = c.y + (height-hostage.height)/2
					}
				}
			}
		shoot(){
			. = ..()
			if(hostage){
				hostage = null
				}
			}
		hurt(amount, var/game/map/mover/combatant/attacker, var/game/map/mover/projectile/proxy){
			var/game/enemy/blob/jump_shadow/shadow = intelligence
			if(istype(shadow)){
				return
				}
			if(attacker == hostage){ return}
			var/jump = FALSE
			if(hostage){
				hostage.hurt(amount, attacker, proxy)
				jump = TRUE
				}
			else{
				jump = pick(TRUE,FALSE,FALSE,FALSE)
				}
			. = ..()
			if(health){
				if(jump){
					shoot()
					}
				}
			}
		shoot(){
			if(hostage && rand()*3 > 2){
				return
				}
			. = ..()
			}
		jump_shadow{
			parent_type = /game/map/mover
			icon = 'large.dmi'
			icon_state = "blob_shadow"
			movement = MOVEMENT_ALL
			var{
				direction = 1
				jump_time
				total_time = 0
				coord/target
				game/enemy/blob/owner
				}
			New(_owner){
				. = ..()
				owner = _owner
				owner.invincible = TRUE
				owner.jump_shadow = src
				owner.intelligence = src
				owner.underlays.Cut()
				}
			proc{
				intelligence(var/game/enemy/blob/blob){
					if(!target){
						c.x = blob.c.x
						c.y = blob.c.y
						var/game/hero/H = pick(game.heros - blob.hostage)
						if(H){
							target = new(0,0)
							target.x = H.c.x + (H.width -width )/2
							target.y = H.c.y + (H.height-height)/2
							}
						else{
							target = new(rand(TILE_WIDTH*2,(world.maxx-1)*TILE_WIDTH), rand(TILE_WIDTH*2,(world.maxx-2)*TILE_WIDTH))
							}
						}
					var/d_x = target.x - c.x
					var/d_y = target.y - c.y
					c.x += d_x / (64-total_time)
					c.y += d_y / (64-total_time)
					blob.icon_state = "blob_[blob.level]_jump"
					blob.invulnerable = 3
					blob.c.x = c.x
					blob.c.y = c.y
					jump_time += direction
					total_time++
					if(jump_time >= 32){
						direction = -1
						}
					blob.y_offset = -80*(((total_time-32)/32)*((total_time-32)/32))+80
					if(jump_time <= 0){
						land(blob)
						}
					redraw()
					}
				land(var/game/enemy/blob/blob){
					blob.invincible = FALSE
					blob.y_offset = 0
					blob.icon_state = initial(blob.icon_state)
					blob.underlays.Add(image(icon, blob, "blob_[blob.level]_back", blob.layer-2))
					Del()
					}
				}
			}
		_1{
			icon_state = "blob_1_front"
			level = 1
			max_health = 7
			score = 40
			}
		_2{
			icon_state = "blob_2_front"
			level = 2
			max_health = 13
			score = 65
			}
		_3{
			icon_state = "blob_3_front"
			level = 3
			max_health = 19
			score = 120
			}
		}
	bouncing_skull{
		parent_type = /game/enemy/archetype/normal
		projectile_type = null
		icon = 'large.dmi'
		icon_state = "skull_1"
		movement = MOVEMENT_ALL
		width = 24
		height = 24
		x_offset = -2
		y_offset = 0
		layer = MOB_LAYER+1
		undead = TRUE
		var{
			level = 1
			game/enemy/bouncing_skull/jump_shadow/shadow
			game/hero/target
			}
		Del(){
			del shadow
			. = ..()
			}
		New(){
			. = ..()
			shadow = new(src)
			}
		attack(var/game/map/mover/combatant/target, amount, var/game/map/mover/projectile/proxy){
			if(y_offset >= 12){ return}
			. = ..()
			}
		hurt(amount, var/game/map/mover/combatant/attacker, var/game/map/mover/projectile/proxy){
			if(y_offset >= 18){ return}
			if(!target){
				target = attacker
				}
			. = ..()
			}
		behavior(){
			if(!target){
				. = ..()
				}
			else{
				var/trans_x = 0
				var/trans_y = 0
				if(target.c.x != c.x){
					if(target.c.x > c.x){ trans_x = speed}
					else{ trans_x = -speed}
					}
				if(target.c.y != c.y){
					if(target.c.y > c.y){ trans_y = speed}
					else{ trans_y = -speed}
					}
				px_move(trans_x, trans_y)
				}
			shadow.behavior()
			switch(y_offset){
				if(0){
					if(target){
						if(rand()*6 > 5){
							target = null
							}
						}
					else if(rand()*8 > 7){
						target = pick(game.heros)
						}
					}
				if(1 to 20){
					if(icon_state == "skull_[level]_open"){
						icon_state = "skull_[level]"
						}
					}
				if(21 to 24){
					if(icon_state == "skull_[level]"){
						icon_state = "skull_[level]_open"
						}
					}
				}
			if(FALSE && level == 3 && pick(0,0,1)){
				switch(y_offset){
					if(16 to 24){
						var/old_dir = dir
						dir = SOUTH
						var/game/map/mover/projectile/fire_1/P = new(src)
						P.vel.x = 0
						P.vel.y = -4
						P.c.x += round(rand(-8, 8))
						P.c.y += y_offset+8
						P.persistent = TRUE
						P.movement = MOVEMENT_ALL
						P.layer += 4
						P.max_range = y_offset
						dir = old_dir
						}
					}
				}
			}
		/*behavior(){
			. = ..()
			if(hostage){
				if(!collision_check(hostage)){ hostage = null}
				else{
					hostage.c.x = c.x + (width -hostage.width )/2
					hostage.c.y = c.y + (height-hostage.height)/2
					}
				}
			}*/
		jump_shadow{
			parent_type = /game/map/mover
			icon = 'large.dmi'
			icon_state = "skull_shadow"
			movement = MOVEMENT_ALL
			x_offset = -2
			var{
				direction = 1
				jump_time
				game/enemy/bouncing_skull/owner
				}
			New(_owner){
				. = ..()
				owner = _owner
				}
			behavior(){
				c.x = owner.c.x
				c.y = owner.c.y
				jump_time += direction
				if(!owner.target){
					if(jump_time >= 15){
						direction = -1
						}
					owner.y_offset = (-24*(((jump_time-15)/15)*((jump_time-15)/15))+24)
					}
				else{
					if(jump_time >= 5){
						direction = -1
						}
					owner.y_offset = (-12*(((jump_time-5)/5)*((jump_time-5)/5))+12)
					}
				if(jump_time <= 0){
					direction = 1
					}
				redraw()
				}
			}
		_1{
			icon_state = "skull_1"
			level = 1
			max_health = 7
			score = 40
			}
		_2{
			icon_state = "skull_2"
			level = 2
			max_health = 13
			touch_damage = 2
			score = 60
			}
		_3{
			icon_state = "skull_3"
			level = 3
			max_health = 19
			touch_damage = 3
			score = 100
			}
		}
	demon{
		parent_type = /game/enemy/archetype/normal
		demon = TRUE
		icon = 'large.dmi'
		icon_state = "demon_1"
		width = 30
		height = 30
		x_offset = -1
		y_offset = -1
		var{
			using_skill = -128
			skill
			skill_dir
			coord/skill_target
			list/bats = new()
			bat_type = /game/enemy/bat/_1
			}
		_1{
			icon_state = "demon_1"
			max_health = 7
			score = 40
			}
		_2{
			icon_state = "demon_2"
			bat_type = /game/enemy/bat/_2
			max_health = 13
			touch_damage = 2
			score = 65
			}
		_3{
			icon_state = "demon_3"
			bat_type = /game/enemy/bat/_3
			max_health = 19
			touch_damage = 2
			score = 120
			}
		hurt(amount,attacker, var/game/map/mover/projectile/proxy){
			if(skill == "teleport"){
				game.audio.play_sound("defend")
				return
				}
			. = ..()
			}
		die(){
			for(var/game/enemy/B in bats){
				B.die()
				}
			. = ..()
			}
		behavior(){
			if(using_skill > 0){
				using_skill--
				switch(skill){
					if("breathing"){
						if(!(using_skill%8)){
							var/game/map/mover/projectile/magic_2/F = new(src)
							F.layer = layer+1
							F.x = c.x + (width -F.width )/2
							F.y = c.y + (height-F.height)/2
							F.vel.x = cos(skill_dir)*3
							F.vel.y = sin(skill_dir)*3
							}
						}
					if("bats"){
						if(!(using_skill%8)){
							var/game/enemy/bat/B = new bat_type()
							bats.Add(B)
							B.c.x = c.x+(width -B.width )/2
							B.c.y = c.y+(height-B.height)/2
							B.layer = layer+1
							B.dir = dir
							}
						}
					if("spew"){
						if(!(using_skill%6)){
							dir = skill_dir
							var/game/map/mover/projectile/stationary_fire/F = new(src)
							F.layer = layer+1
							F.max_range = 64
							F.vel.x = cos(skill_dir)*3
							F.vel.y = sin(skill_dir)*3
							}
						skill_dir+=2
						}
					if("teleport"){
						px_move(skill_target.x, skill_target.y)
						}
					}
				}
			else if(using_skill == 0){
				if(skill){
					if(skill == "teleport"){
						c.x += (width -initial(width ))/2
						c.y += (height-initial(height))/2
						icon = initial(icon)
						width = initial(width)
						height = initial(height)
						movement = initial(movement)
						}
					skill = FALSE
					icon_state = initial(icon_state)
					using_skill = -96
					}
				else{
					using_skill = 32
					skill = pick("breathing", "bats", "spew", "teleport")
					icon_state = "[icon_state]_cast"
					switch(skill){
						if("breathing"){
							var/game/hero/H = pick(game.heros)
							skill_dir = arctan(H.c.x-c.x, H.c.y-c.y)
							}
						if("bats"){}
						if("spew"){
							var/game/hero/H = pick(game.heros)
							skill_dir = arctan(H.c.x-c.x, H.c.y-c.y)-32
							}
						if("teleport"){
							using_skill = 64
							icon = 'enemies.dmi'
							icon_state = "darkness_1"
							width = 14
							height = 14
							movement = MOVEMENT_ALL
							c.x += (initial(width )-width )/2
							c.y += (initial(height)-height)/2
							var/game/hero/H = pick(game.heros)
							skill_dir = arctan(H.c.x-c.x, H.c.y-c.y)
							skill_target = coord((H.c.x-c.x)/using_skill, (H.c.y-c.y)/using_skill)
							}
						}
					}
				}
			else if(using_skill < 0){
				if(rand()*24 > 23){
					var/game/enemy/B = locate() in bats
					if(B){
						bats.Remove(B)
						del B
						}
					}
				using_skill++
				. = ..()
				}
			}
		}
	eye_mass{
		parent_type = /game/enemy/archetype/ball
		child_type = /game/enemy/eye/
		icon = 'large.dmi'
		child_distance = 4
		move_toggle = 0
		width = 24
		height = 24
		_1{
			icon_state = "eye_1"
			group_size = 6
			max_health = 3
			child_type = /game/enemy/eye/_1
			score = 60
			}
		_2{
			icon_state = "eye_2"
			group_size = 13
			max_health = 5
			respawn_time = 256
			child_type = /game/enemy/eye/_2
			score = 100
			}
		_3{
			icon_state = "eye_3"
			group_size = 18
			max_health = 9
			child_type = /game/enemy/eye/_3
			respawn_time = 176
			score = 200
			}
		}
	dragon{
		parent_type = /game/enemy/archetype/normal
		icon = 'large.dmi'
		width = 30
		height = 28
		x_offset = -1
		projectile_type = /game/map/mover/projectile/fire_large
		var{
			flapping = 0
			}
		hurt(){
			. = ..()
			icon_state = "[initial(icon_state)]_flap"
			flapping = 96
			}
		behavior(){
			if(!flapping){
				. = ..()
				/*if(rand()*256 > 255){
					icon_state = "[icon_state]_flap"
					flapping = 96
					}*/
				}
			else{
				flapping--
				if(!(flapping%2)){
					var/game/map/mover/projectile/wind/W = new(src)
					W.c.x = c.x + ((width -W.width )/2)
					W.c.y = c.y + ((height-W.height)/2)
					var/angle = rand(0,359)
					W.vel.x = cos(angle)*5
					W.vel.y = sin(angle)*5
					}
				if(!flapping){
					icon_state = initial(icon_state)
					}
				}
			}
		shoot(){
			new projectile_type(src)
			switch(dir){
				if(NORTH, SOUTH){
					c.x -= 12
					new /game/map/mover/projectile/fire_1(src)
					c.x += 24
					new /game/map/mover/projectile/fire_1(src)
					c.x -= 12
					}
				if(EAST, WEST){
					c.y -= 12
					new /game/map/mover/projectile/fire_1(src)
					c.y += 24
					new /game/map/mover/projectile/fire_1(src)
					c.y -= 12
					}
				}
			}
		_1{
			icon_state = "dragon_1"
			max_health = 6
			touch_damage = 2
			score = 40
			}
		_2{
			icon_state = "dragon_2"
			max_health = 9
			move_toggle = -1
			touch_damage = 3
			score = 60
			}
		_3{
			icon_state = "dragon_3"
			max_health = 12
			move_toggle = -1
			speed = 2
			touch_damage = 4
			score = 100
			}
		}
	boss_knight{
		parent_type = /game/enemy/archetype/normal
		icon = 'large.dmi'
		width = 24
		height = 24
		projectile_type = /game/map/mover/projectile/sword
		front_protection = TRUE
		var{
			game/map/mover/projectile/sword/sword
			}
		shoot(){
			sword = new projectile_type(src)
			}
		behavior(){
			if(sword){ return}
			. = ..()
			if(rand()*40 > 39){
				var/game/hero/H = locate() in range(COLLISION_RANGE, src)
				if(!H){ H = pick(game.heros)}
				dir = dir_to(H)
				switch(dir){
					if(NORTH){ bearing =  90}
					if(SOUTH){ bearing = 270}
					if(EAST ){ bearing =   0}
					if(WEST ){ bearing = 180}
					}
				}
			}
		_1{
			icon_state = "knight_1"
			max_health = 6
			touch_damage = 2
			score = 40
			}
		_2{
			icon_state = "knight_2"
			max_health = 9
			touch_damage = 2
			score = 80
			}
		_3{
			icon_state = "knight_3"
			max_health = 12
			touch_damage = 4
			score = 160
			}
		}
	tarantula{
		parent_type = /game/enemy/archetype/normal
		icon = 'large.dmi'
		width = 30
		height = 30
		x_offset = -1
		y_offset = -1
		projectile_type = /game/map/mover/projectile/silk
		shoot_frequency = 64
		movement = MOVEMENT_ALL
		var{
			coord/target
			target_time = 96
			}
		behavior(){
			if(!target){
				return ..()
				}
			else{
				target_time--
				speed = 2
				if(target_time <= 0){
					del target
					speed = initial(speed)
					return ..()
					}
				var/trans_x = 0 //sign(target.x - (c.x + width /2))
				var/trans_y = 0 //sign(target.y - (c.y + height/2))
				if(target.x){
					trans_x = sign(target.x - (c.x + width /2))
					}
				if(target.y){
					trans_y = sign(target.y - (c.y + height/2))
					}
				px_move(trans_x, trans_y)
				}
			}
		shoot(){
			if(projectiles.len >= 20){
				var/first = projectiles[1]
				projectiles.Remove(first)
				del first
				}
			dir = turn(dir, 180)
			. = ..()
			dir = turn(dir, 180)
			}
		_1{
			icon_state = "spider_1"
			max_health = 6
			touch_damage = 2
			score = 30
			}
		_2{
			icon_state = "spider_2"
			max_health = 9
			touch_damage = 3
			shoot_frequency = 48
			score = 60
			}
		_3{
			icon_state = "spider_3"
			max_health = 12
			move_toggle = -1
			touch_damage = 4
			shoot_frequency = 32
			score = 120
			}
		}
	bowser{
		parent_type = /game/enemy/archetype/snaking
		icon_state = "dragon_head_1"
		body_state = "dragon_body_1"
		tail_state = "dragon_tail_1"
		width = 16
		height = 16
		body_radius = 12
		body_health = 2
		move_toggle = -1
		length = 16
		speed = 1
		projectile_type = /game/map/mover/projectile/fire_1
		_1{
			icon_state = "dragon_head_1"
			body_state = "dragon_body_1"
			tail_state = "dragon_tail_1"
			projectile_type = /game/map/mover/projectile/fire_1
			length = 4
			score = 30
			}
		_2{
			icon_state = "dragon_head_2"
			body_state = "dragon_body_2"
			tail_state = "dragon_tail_2"
			projectile_type = /game/map/mover/projectile/fire_2
			length = 8
			score = 60
			}
		_3{
			icon_state = "dragon_head_3"
			body_state = "dragon_body_3"
			tail_state = "dragon_tail_3"
			projectile_type = /game/map/mover/projectile/fire_large
			length = 12
			speed = 2
			score = 110
			}
		}
	spine{
		parent_type = /game/enemy/archetype/snaking
		icon_state = "skull_1"
		body_state = "spine"
		undead = TRUE
		width = 13
		height = 16
		length = 8
		body_radius = 8
		speed = 2
		_1{
			length = 4
			score = 20
			}
		_2{
			icon_state = "skull_2"
			projectile_type = /game/map/mover/projectile/bone
			score = 50
			}
		_3{
			max_health = 4
			icon_state = "skull_3"
			body_state = "spine_2"
			length = 8
			projectile_type = /game/map/mover/projectile/bone
			score = 90
			}
		}
	reaper{
		parent_type = /game/enemy/archetype/diagonal
		icon = 'large.dmi'
		icon_state = "reaper_1"
		speed = 1
		width = 30
		height = 30
		y_offset = -2
		x_offset = -2
		undead = TRUE
		var{
			projectile_type = /game/map/mover/projectile/seeker_1
			shoot_frequency = 96
			}
		behavior(){
			if(rand()*96 > 95){
				bearing = pick(45, 135, 225, 315)
				}
			if(projectile_type && rand()*shoot_frequency > shoot_frequency-1){
				new projectile_type(src)
				}
			. = ..()
			}
		_1{
			icon_state = "reaper_1"
			projectile_type = null
			max_health = 7
			touch_damage = 2
			score = 35
			}
		_2{
			icon_state = "reaper_2"
			max_health = 9
			touch_damage = 3
			score = 70
			}
		_3{
			icon_state = "reaper_3"
			projectile_type = /game/map/mover/projectile/seeker_2
			shoot_frequency = 64
			max_health = 11
			touch_damage = 4
			score = 150
			}
		}
	fire_wall{
		parent_type = /game/enemy/archetype/snaking
		max_health = 1
		body_health = 1
		body_invulnerable = FALSE
		_1{
			icon_state = "fire_1"
			body_state = "fire_1"
			touch_damage = 2
			body_radius = 16
			length = 2
			move_toggle = -1
			score = 15
			}
		_2{
			icon_state = "fire_2"
			body_state = "fire_2"
			touch_damage = 2
			body_radius = 16
			length = 4
			max_health = 2
			body_health = 2
			move_toggle = -1
			score = 35
			}
		_3{
			icon_state = "fire_3"
			body_state = "fire_3"
			touch_damage = 2
			body_radius = 16
			length = 3
			max_health = 3
			body_health = 3
			speed = 3
			move_toggle = 0
			score = 80
			}
		}
	scorpion{
		parent_type = /game/enemy/archetype/normal
		icon = 'large.dmi'
		width = 30
		height = 32
		x_offset = -1
		var{
			level = 1
			}
		var{
			coord/target
			target_time = 0
			game/enemy/scorpion/part/left_claw
			game/enemy/scorpion/part/right_claw
			right_claw_time = 0
			left_claw_time = 0
			list/tail
			}
		part{
			parent_type = /game/enemy
			hurt(){
				game.audio.play_sound("defend")
				return
				}
			}
		hurt(amount, var/game/map/mover/attacker, var/game/map/mover/projectile/proxy){
			if(proxy && dir_to(proxy) != SOUTH){
				game.audio.play_sound("defend")
				return
				}
			if(dir_to(attacker) != SOUTH){
				game.audio.play_sound("defend")
				return
				}
			. = ..()
			}
		die(){
			for(var/game/enemy/E in tail){
				E.die()
				}
			left_claw.die()
			right_claw.die()
			. = ..()
			}
		Del(){
			for(var/game/enemy/E in tail){ del E}
			del left_claw
			del right_claw
			. = ..()
			}
		New(){
			. = ..()
			left_claw             = new()
			left_claw.width       = 16
			left_claw.height      = 16
			left_claw.layer       = layer+2
			right_claw            = new()
			right_claw.width      = 16
			right_claw.height     = 16
			right_claw.layer      = layer+2
			left_claw.c.x         = ((c.x+width /2) - 12) - left_claw.width /2
			left_claw.c.y         = c.y-8
			right_claw.c.x        = ((c.x+width /2) + 12) - left_claw.width /2
			right_claw.c.y        = c.y-8
			left_claw.icon        = 'enemies.dmi'
			left_claw.icon_state  = "scorpion_[level]_claw"
			left_claw.dir         = EAST
			right_claw.icon       = 'enemies.dmi'
			right_claw.icon_state = "scorpion_[level]_claw"
			right_claw.dir        = WEST
			tail = new(8)
			for(var/I = 1 to tail.len){
				var/game/enemy/scorpion/part/E = new()
				if(I == tail.len){
					E.icon_state = "scorpion_[level]_sting"
					E.layer = layer+2
					E.height = 16
					E.width  = 12
					}
				else{
					E.icon_state = "scorpion_[level]_segment"
					E.layer = layer+1
					E.height = 8
					E.width  = 12
					}
				E.icon   = 'enemies.dmi'
				E.touch_damage = touch_damage
				E.c.y    = c.y+height
				E.c.x    = c.x+(width-E.width)/2
				tail[I] = E
				}
			icon_state = "scorpion_[level]"
			}
		behavior(){
			/*if(bearing == 90 || bearing == 270){
				bearing = pick(0, 180)
				}*/
			if(!target){
				// Claws
				left_claw.c.x         = ((c.x+width /2) - 12) - left_claw.width /2
				right_claw.c.x        = ((c.x+width /2) + 12) - left_claw.width /2
				if(left_claw_time){
					if(left_claw_time  > 16){  left_claw.c.y = c.y-4 - (32- left_claw_time)}
					else{                      left_claw.c.y = c.y-4 - (    left_claw_time)}
					left_claw_time--
					}
				else{
					left_claw.c.y = c.y-4
					if(!right_claw_time && rand()*96 > 95){
						left_claw_time = 32
						}
					}
				if(right_claw_time){
					if(right_claw_time > 16){ right_claw.c.y = c.y-4 - (32-right_claw_time)}
					else{                     right_claw.c.y = c.y-4 - (   right_claw_time)}
					right_claw_time--
					}
				else{
					right_claw.c.y = c.y-4
					if(!left_claw_time && rand()*96 > 95){
						right_claw_time = 32
						}
					}
				// Tail
				for(var/game/enemy/E in tail){
					E.c.y    = (c.y+height)-2
					E.c.x    = (c.x+(width-E.width)/2)+1
					if(E.icon_state == "scorpion_[level]_sting"){
						E.c.x -= 2
						}
					}
				if(rand()*256 > 255){
					var/game/hero/H = pick(game.heros)
					target = coord(H.c.x+(H.width/2), H.c.y+(H.height/2))
					target_time = 106
					}
				return ..()
				}
			else if(target_time > 96){
				var/game/enemy/E = tail[tail.len]
				E.icon_state = "scorpion_sting_ready"
				target_time--
				}
			else{
				var/coord/delta = coord(target.x - (c.x+width/2), target.y - (c.y+height/2))
				var/factor
				if(target_time > 64){
					factor = (97-target_time)/32
					}
				else{
					factor = (target_time)/64
					if(target_time == 64){
						var/game/map/mover/projectile/acid/A = new(src)
						var/game/enemy/E = tail[tail.len]
						E.icon_state = "scorpion_[level]_sting"
						A.c.x = target.x - A.width/2
						A.c.y = target.y - A.width/2
						}
					}
				delta.x *= factor
				delta.y *= factor
				for(var/I = tail.len to 1 step -1){
					var/game/enemy/E = tail[I]
					E.c.x    = (c.x+(width-E.width)/2)+1 + (I*(delta.x))/tail.len
					E.c.y    = (c.y+(height)) + (I*(delta.y))/tail.len - (height/2)*factor*(I/tail.len)
					if(I == tail.len){
						E.c.y -= 8*factor
						}
					}
				target_time--
				if(!target_time){
					del target
					}
				}
			}
		_1{
			icon_state = "scorpion_1"
			level = 1
			max_health = 6
			touch_damage = 2
			score = 45
			}
		_2{
			icon_state = "scorpion_2"
			level = 2
			max_health = 9
			touch_damage = 3
			score = 90
			}
		_3{
			icon_state = "scorpion_3"
			level = 3
			max_health = 12
			touch_damage = 4
			score = 180
			}
		}
	}
game/enemy{
	delayed{
		parent_type = /game/enemy/archetype/normal
		var{
			coord/start_coord
			started = FALSE
			}
		die(){
			var/game/map/region/pagota/P = game.map.region
			if(istype(P)){
				P.ninja.Remove(src)
				}
			. = ..()
			}
		take_turn(){
			. = ..()
			if(!start_coord && c){
				start_coord = c.Copy()
				c.x = 0
				c.y = 0
				icon = null
				invulnerable = 3
				return
				}
			else if(!started){
				var/game/map/region/pagota/P = game.map.region
				if(P.ninja.len <= 3 && rand()*4>3){
					started = TRUE
					c = start_coord
					invulnerable = INVULNERABLE_TIME
					redraw()
					icon = initial(icon)
					P.ninja.Add(src)
					}
				return
				}
			}
		}
	shinto{
		parent_type = /game/enemy/delayed
		icon = 'ninja.dmi'
		icon_state = "monk"
		//move_toggle = -1
		speed = 3
		max_health = 6
		score = 120
		var{
			game/enemy/friend
			heal_rate = 52
			}
		behavior(){
			if(started){
				if(icon_state != "monk"){
					icon_state = "monk"
					}
				if(projectiles.len){
					return
					}
				if(!friend){
					var/game/map/region/pagota/P = game.map.region
					if(istype(P) && P.ninja.len >= 2){
						friend = pick(P.ninja - src)
						}
					if(!friend){
						friend = src
						}
					}
				if(friend && rand()*(20/3) > (20/3)-1){
					dir = dir_to(friend)
					switch(dir){
						if(NORTH){ bearing =  90}
						if(SOUTH){ bearing = 270}
						if(EAST ){ bearing =   0}
						if(WEST ){ bearing = 180}
						}
					}
				if(friend && rand()*heal_rate > heal_rate-1){
					heal()
					}
				if(!collision_check(friend) || friend == src){
					. = ..()
					}
				}
			}
		proc{
			heal(){
				intelligence = new /game/map/mover/intelligence/freezer(9)
				icon_state = "monk_cast"
				var/heal_range = 32
				var/potency = 3
				for(var/I = 1 to 4){
					var/game/hero/projectile/healing/H = new(src)
					H.icon_state = "heal_2"
					H.c.x = c.x + (width -H.width )/2
					H.c.y = c.y + (height-H.height)/2
					switch(I){
						if(1){ H.vel.x =  3; H.vel.y =  3}
						if(2){ H.vel.x = -3; H.vel.y =  3}
						if(3){ H.vel.x = -3; H.vel.y = -3}
						if(4){ H.vel.x =  3; H.vel.y = -3}
						}
					}
				for(var/game/enemy/H in range(COLLISION_RANGE, src)){
					var/d_x = abs((c.x+(width /2)) - (H.c.x+(H.width /2)))
					var/d_y = abs((c.y+(height/2)) - (H.c.y+(H.height/2)))
					if(min(d_x, d_y) <= heal_range){
						H.adjust_health(potency, src)
						if(H != src){
							H.invulnerable = max(H.invulnerable, 6)
							}
						}
					}
				}
			}
		}
	ninja{
		parent_type = /game/enemy/delayed
		icon = 'ninja.dmi'
		var{
			level = 1
			game/hero/saved_target
			}
		projectile_type = /game/enemy/ninja/star
		shoot(){
			if(locate(/game/hero) in orange(src, COLLISION_RANGE-1)){
				projectile_type = /game/enemy/ninja/sword
				}
			else{
				projectile_type = /game/enemy/ninja/star
				}
			. = ..()
			}
		behavior(){
			if(started){
				if(projectiles.len){
					return
					}
				if(rand()*(20/level) > (20/level)-1){
					if(!saved_target){
						saved_target = pick(game.heros)
						}
					dir = dir_to(saved_target)
					switch(dir){
						if(NORTH){ bearing =  90}
						if(SOUTH){ bearing = 270}
						if(EAST ){ bearing =   0}
						if(WEST ){ bearing = 180}
						}
					}
				if(saved_target && !collision_check(saved_target)){
					. = ..()
					}
				}
			}
		New(){
			. = ..()
			icon_state = "[level]"
			}
		star{
			parent_type = /game/map/mover/projectile/magic_1
			icon_state = "star"
			potency = 2
			max_range = 64
			speed = 3
			sound = null
			New(){
				. = ..()
				owner.icon_state = "[owner:level]_attack"
				}
			Del(){
				owner.icon_state = "[owner:level]"
				. = ..()
				}
			}
		sword{
			parent_type = /game/map/mover/projectile
			icon = 'projectiles.dmi'
			sound = "sword"
			impact(var/game/map/mover/combatant/target){
				owner.attack(target, potency)
				}
			height = 3
			width  = 3
			persistent = TRUE
			potency = 2
			var{
				stage = 0
				state_name = "black"
				}
			New(){
				. = ..()
				owner.icon_state = "[owner:level]_attack"
				potency = owner:touch_damage
				}
			behavior(){
				stage++
				dir = owner.dir
				switch(stage){
					if(1,2){
						return
						}
					if(3,7){
						icon_state = "[state_name]_6"
						switch(dir){
							if(NORTH, SOUTH){
								height = 6
								width  = 4
								}
							if( EAST,  WEST){
								height = 4
								width  = 6
								}
							}
						}
					if(4,6){
						icon_state = "[state_name]_11"
						switch(dir){
							if(NORTH, SOUTH){
								height = 11
								width  = 4
								}
							if( EAST,  WEST){
								height = 4
								width  = 11
								}
							}
						}
					if(5){
						icon_state = "[state_name]_16"
						switch(dir){
							if(NORTH, SOUTH){
								height = 16
								width  = 4
								}
							if( EAST,  WEST){
								height = 4
								width  = 16
								}
							}
						}
					if(8){
						owner.icon_state = "[owner:level]"
						del src
						}
					}
				switch(dir){
					if(NORTH){
						c.x = owner.c.x + (owner.width-width)/2
						c.y = owner.c.y + owner.height
						}
					if(SOUTH){
						c.x = owner.c.x + (owner.width-width)/2
						c.y = owner.c.y - height
						}
					if( EAST){
						c.x = owner.c.x + owner.width
						c.y = owner.c.y + (owner.height-height)/2
						}
					if( WEST){
						c.x = owner.c.x - width
						c.y = owner.c.y + (owner.height-height)/2
						}
					}
				}
			redraw(){
				loc = owner.loc
				switch(dir){
					if(NORTH){ pixel_x = owner.pixel_x            ; pixel_y = owner.pixel_y+owner.height}
					if(SOUTH){ pixel_x = owner.pixel_x            ; pixel_y = owner.pixel_y-owner.height}
					if( EAST){ pixel_x = owner.pixel_x+owner.width; pixel_y = owner.pixel_y             }
					if( WEST){ pixel_x = owner.pixel_x-owner.width; pixel_y = owner.pixel_y             }
					}
				}
			}
		_1{
			level = 1
			move_toggle = -1
			touch_damage = 2
			max_health = 4
			score = 100
			}
		_2{
			level = 2
			speed = 3
			touch_damage = 2
			max_health = 8
			score = 200
			}
		_3{
			level = 3
			move_toggle = -1
			speed = 2
			touch_damage = 2
			max_health = 12
			score = 350
			}
		}
	spearer{
		parent_type = /game/enemy/archetype/normal
		icon = 'ninja.dmi'
		icon_state = "spear_man"
		projectile_type = null
		move_toggle = -1
		max_health = 12
		score = 250
		var{
			game/enemy/spearer/spear/spear
			}
		New(){
			. = ..()
			spear = new(src)
			}
		spear{
			parent_type = /game/map/mover/projectile
			icon = 'ninja.dmi'
			icon_state = "spear"
			persistent = TRUE
			potency = 2
			behavior(){
				. = ..()
				dir = owner.dir
				switch(owner.dir){
					if(NORTH){
						width  = 6
						height = 16
						c.x = owner.c.x + (owner.width -width )/2
						c.y = owner.c.y + owner.height
						}
					if(SOUTH){
						width  = 6
						height = 16
						c.x = owner.c.x + (owner.width -width )/2
						c.y = owner.c.y - owner.height
						}
					if(EAST ){
						width  = 16
						height = 6
						c.x = owner.c.x + owner.width
						c.y = owner.c.y + (owner.height-height)/2
						}
					if(WEST ){
						width  = 16
						height = 6
						c.x = owner.c.x - owner.width
						c.y = owner.c.y + (owner.height-height)/2
						}
					}
				}
			}
		}
	shogun{
		parent_type = /game/enemy/archetype/normal
		icon = 'ninja_large.dmi'
		icon_state = "1_shogun"
		projectile_type = /game/enemy/shogun/sword
		move_toggle = -1
		max_health = 30
		width = 20
		height = 20
		score = 4000
		touch_damage = 3
		var{
			level = 1
			game/enemy/shogun/bear/bear
			riding = FALSE
			riding_health = 8
			dismount_time = 750
			setup = FALSE
			list/ninja
			list/passages
			game/enemy/shinto/healer
			dying = FALSE
			}
		New(){
			. = ..()
			boss = TRUE
			var/game/map/region/pagota/pag = game.map.region
			if(istype(pag)){
				ninja = pag.ninja
				}
			passages = new()
			for(var/game/map/tile/passage/P in game.map){
				if((P.movement == MOVEMENT_LAND) && P.y != 1){
					passages.Add(P)
					}
				}
			}
		die(){
			if(!dying){
				touch_damage = 0
				dying = TRUE
				for(var/game/enemy/E){
					if(E == src){ continue}
					E.die()
					}
				health = 256
				return
				}
			game.map.chest = new()
			game.map.chest.icon = null
			. = ..()
			}
		hurt(amount){
			if(dying){ return}
			if(invulnerable){ return}
			if(riding_health > 0){
				invulnerable = INVULNERABLE_TIME
				riding_health -= amount
				if(riding_health <= 0){
					riding = FALSE
					bear.rider = null
					icon_state = "[level]_shogun"
					dismount_time = initial(dismount_time)
					}
				}
			else{
				. = ..()
				}
			}
		take_turn(){
			if(!setup){
				layer += 4
				setup = TRUE
				bear = new()
				bear.c = c.Copy()
				bear.redraw()
				bear.rider = src
				riding = TRUE
				}
			. = ..()
			}
		behavior(){
			if(dying){
				health--
				if(health <= 0){ die()}
				x_offset = pick(-2,2)
				y_offset = pick(-2,2)
				return
				}
			if(!healer && rand()*256 > 255){
				var/game/map/tile/T = pick(passages)
				if(T){
					healer = new(T)
					healer.score = 0
					healer.c.x = (T.x-1)*TILE_WIDTH
					healer.c.y = (T.y-1)*TILE_HEIGHT
					healer.speed = 2
					healer.heal_rate = 150
					healer.take_turn()
					healer.take_turn()
					healer.take_turn()
					healer.take_turn()
					healer.take_turn()
					healer.take_turn()
					healer.friend = src
					}
				}
			if(ninja.len < 3 && rand()*128 > 127){
				var/ninja_type = pick(
					/game/enemy/ninja/_1,
					/game/enemy/ninja/_1,
					/game/enemy/ninja/_2,
					/game/enemy/ninja/_2,
					/game/enemy/ninja/_2,
					/game/enemy/ninja/_3,
					)
				var/game/map/tile/T = pick(passages)
				if(T){
					var/game/enemy/ninja/N = new ninja_type(T)
					N.score = 0
					N.c.x = (T.x-1)*TILE_WIDTH
					N.c.y = (T.y-1)*TILE_HEIGHT
					N.take_turn()
					N.take_turn()
					N.take_turn()
					N.take_turn()
					N.take_turn()
					N.take_turn()
					}
				}
			if(riding && bear){
				icon_state = "[level]_shogun_ride"
				dir = bear.dir
				c.x = bear.c.x + (bear.width  - width )/2
				c.y = bear.c.y + (bear.height - height)/2
				switch(dir){
					if(NORTH, SOUTH){
						c.y += 4
						}
					if(EAST ){
						c.x -= 2
						c.y += 12
						}
					if(WEST ){
						c.x += 2
						c.y += 12
						}
					}
				}
			else{
				if(projectiles.len){
					return
					}
				if(bear){
					dir = dir_to(bear)
					switch(dir){
						if(NORTH){ bearing =  90}
						if(SOUTH){ bearing = 270}
						if(EAST ){ bearing =   0}
						if(WEST ){ bearing = 180}
						}
					if(dismount_time-- <= 0){
						if(collision_check(bear)){
							riding = TRUE
							bear.rider = src
							icon_state = "[level]_shogun_ride"
							riding_health = initial(riding_health)
							}
						}
					}
				else{
					shoot_frequency = 48
					}
				. = ..()
				}
			}
		shoot(){
			if(locate(/game/hero) in orange(src, COLLISION_RANGE-1)){
				projectile_type = /game/enemy/shogun/sword
				}
			else{
				projectile_type = /game/enemy/shogun/star
				}
			. = ..()
			}
		star{
			parent_type = /game/map/mover/projectile/magic_1
			icon = 'ninja_large.dmi'
			icon_state = "star"
			potency = 2
			max_range = 128
			speed = 4
			sound = null
			width = 16
			height = 16
			New(){
				. = ..()
				owner.icon_state = "[owner:level]_shogun_attack"
				}
			Del(){
				owner.icon_state = "[owner:level]_shogun"
				. = ..()
				}
			}
		bear{
			parent_type = /game/enemy/archetype/normal
			icon = 'ninja_large.dmi'
			icon_state = "bear"
			projectile_type = null
			touch_damage = 3
			move_toggle = -1
			speed = 1
			max_health = 20
			var{
				game/enemy/shogun/rider
				}
			hurt(damage, var/game/map/mover/combatant/attacker, var/game/map/mover/projectile/proxy){
				if(!rider){
					. = ..()
					}
				else{
					invulnerable = INVULNERABLE_TIME
					attacker.attack(rider, damage, proxy)
					}
				}
			adjust_health(amount){
				if(amount > 0 && health){ return}
				. = ..()
				}
			behavior(){
				if(rider){
					speed = 1
					}
				else{
					speed = 2
					}
				. = ..()
				switch(dir){
					if(NORTH){
						width  = 16
						height = 32
						}
					if(SOUTH){
						width  = 16
						height = 32
						}
					if(EAST ){
						width  = 32
						height = 16
						}
					if(WEST ){
						width  = 32
						height = 16
						}
					}
				}
			}
		sword{
			parent_type = /game/map/mover/projectile
			icon = 'ninja_large.dmi'
			sound = "sword"
			height = 3
			width  = 3
			persistent = TRUE
			potency = 4
			var{
				stage = 0
				state_name = "sword"
				}
			New(){
				. = ..()
				owner.icon_state = "[owner:level]_shogun_attack"
				}
			behavior(){
				stage++
				dir = owner.dir
				switch(stage){
					if(1,2){
						return
						}
					if(3,7){
						icon_state = "[state_name]_[owner:level]_7"
						switch(dir){
							if(NORTH, SOUTH){
								height = 7
								width  = 4
								}
							if( EAST,  WEST){
								height = 4
								width  = 7
								}
							}
						}
					if(4,6){
						icon_state = "[state_name]_[owner:level]_14"
						switch(dir){
							if(NORTH, SOUTH){
								height = 14
								width  = 4
								}
							if( EAST,  WEST){
								height = 4
								width  = 14
								}
							}
						}
					if(5){
						icon_state = "[state_name]_[owner:level]_20"
						switch(dir){
							if(NORTH, SOUTH){
								height = 20
								width  = 4
								}
							if( EAST,  WEST){
								height = 4
								width  = 20
								}
							}
						}
					if(8){
						owner.icon_state = "[owner:level]_shogun"
						del src
						}
					}
				switch(dir){
					if(NORTH){
						c.x = owner.c.x + (owner.width-width)/2
						c.y = owner.c.y + owner.height
						}
					if(SOUTH){
						c.x = owner.c.x + (owner.width-width)/2
						c.y = owner.c.y - height
						}
					if( EAST){
						c.x = owner.c.x + owner.width
						c.y = owner.c.y + (owner.height-height)/2
						}
					if( WEST){
						c.x = owner.c.x - width
						c.y = owner.c.y + (owner.height-height)/2
						}
					}
				}
			redraw(){
				loc = owner.loc
				switch(dir){
					if(NORTH){ pixel_x = owner.pixel_x            ; pixel_y = owner.pixel_y+owner.height}
					if(SOUTH){ pixel_x = owner.pixel_x            ; pixel_y = owner.pixel_y- 20         }
					if( EAST){ pixel_x = owner.pixel_x+owner.width; pixel_y = owner.pixel_y             }
					if( WEST){ pixel_x = owner.pixel_x- 20        ; pixel_y = owner.pixel_y             }
					}
				}
			}
		}
	// George Gnome
	mrbubble{
		parent_type = /game/enemy/archetype/normal
		icon = 'gnome_enemies.dmi'
		speed = 3
		move_toggle = -1
		projectile_type = null
		icon_state = "mrbubble"
		max_health = 4
		touch_damage = 4
		score = 100
		behavior(){
			if(pick(1,0)){
				bearing = pick(0,90,180,270,360)
				. = ..()
				}
			}
		}
	salty{
		parent_type = /game/enemy/archetype/normal
		icon = 'gnome_enemies.dmi'
		icon_state = "crab_1"
		speed = 3
		projectile_type = null
		//move_toggle = -1
		_1{
			icon_state = "crab_1"
			max_health = 7
			touch_damage = 2
			score = 100
			}
		_2{
			icon_state = "crab_2"
			max_health = 10
			touch_damage = 3
			score = 200
			}
		}
	mobius{
		parent_type  = /game/enemy/archetype/normal
		icon = 'gnome_large.dmi'
		icon_state = "mobius"
		speed = 1
		width = 32
		height = 22
		y_offset = -2
		var{
			pole = -1/10
			}
		New(){
			. = ..()
			dir = EAST
			}
		behavior(){
			if(c.x <= 16){ dir = EAST}
			else if(c.x >= 224){ dir = WEST}
			if(c.y <= 16){ pole = 1/10}
			else if(c.y >= 224){ pole = -1/10}
			switch(dir){
				if(EAST){ translate( speed, pole)}
				if(WEST){ translate(-speed, pole)}
				}
			}
		horizontal_stop(){
			dir = turn(dir,180)
			}
		vertical_stop(){
			pole *= pick(1,-1)
			}
		density = TRUE
		max_health = 20
		touch_damage = 4
		score = 100
		}
	mole{
		parent_type = /game/enemy/archetype/normal
		icon = 'gnome_enemies.dmi'
		icon_state = "mole"
		var{
			game/hero/saved_target
			}
		behavior(){
			if(rand()*8 > 7){
				if(!saved_target){
					saved_target = pick(game.heros)
					}
				dir = dir_to(saved_target)
				switch(dir){
					if(NORTH){ bearing =  90}
					if(SOUTH){ bearing = 270}
					if(EAST ){ bearing =   0}
					if(WEST ){ bearing = 180}
					}
				}
			if(saved_target && !collision_check(saved_target)){
				. = ..()
				}
			}
		move_toggle = -1
		speed = 1
		touch_damage = 4
		max_health = 12
		score = 300
		}
	gnome{
		parent_type = /game/enemy/archetype/normal
		icon = 'gnome_enemies.dmi'
		icon_state = "gnome"
		var{
			game/hero/saved_target
			gnome_color = 1
			}
		New(){
			. = ..()
			gnome_color = pick(1,2)
			icon_state = "gnome_[gnome_color]"
			}
		projectile_type = /game/map/mover/projectile/radish
		behavior(){
			if(rand()*8 > 7){
				if(!saved_target){
					saved_target = pick(game.heros)
					}
				dir = dir_to(saved_target)
				switch(dir){
					if(NORTH){ bearing =  90}
					if(SOUTH){ bearing = 270}
					if(EAST ){ bearing =   0}
					if(WEST ){ bearing = 180}
					}
				}
			if(saved_target && !collision_check(saved_target)){
				. = ..()
				}
			}
		move_toggle = -1
		speed = 1
		touch_damage = 4
		max_health = 18
		score = 300
		}
	}