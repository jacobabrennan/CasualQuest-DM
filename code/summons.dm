

game/hero{
	summon{
		icon = 'summons.dmi'
		tombing = FALSE
		scoring = FALSE
		var{
			game/hero/owner
			}
		New(var/game/hero/_owner){
			. = ..()
			owner = _owner
			c = owner.c.Copy()
			invulnerable = INVULNERABLE_TIME
			}
		take_turn(){
			if(!player){
				if(!owner){ die()}
				if(game.stage != STAGE_PLAY){ die()}
				}
			. = ..()
			}
		fire{
			parent_type = /game/hero/summon/archetype/normal
			max_health = 6
			max_aura = 1
			aura_rate = 100
			icon_state = "fire"
			move_toggle = TRUE
			projectile_type = /game/hero/projectile/magic_1
			skill1_cost = 1
			skill1 = /game/hero/skill/fireball
			behavior(){
				. = ..()
				if(!projectiles.len){
					var/game/enemy/E = locate() in orange(COLLISION_RANGE, src)
					if(E){
						if(abs(E.c.x - c.x) >= abs(E.c.y - c.y)){
							if(E.c.x >= c.x){ dir = EAST }
							else{             dir = WEST }
							}
						else{
							if(E.c.y >= c.y){ dir = NORTH}
							else{             dir = SOUTH}
							}
						if((aura-skill1_cost)>=0) {
							var/game/hero/skill/new_skill = new skill1(src)
							adjust_aura(-skill1_cost)
							new_skill.activate()
							}
						}
					}
				}
			}
		wind{
			icon_state = "cloud"
			max_aura = 10
			aura_rate = 50
			width = 0
			height = 0
			x_offset = -8
			y_offset = -8
			speed = 1/2
			movement = MOVEMENT_ALL
			skill1_cost = 1
			skill1 = /game/hero/skill/cloud_blow
			var{
				max_dist = 32
				}
			behavior(){
				. = ..()
				icon_state = initial(icon_state)
				var/delta_x = (owner.c.x+(owner.width /2)) - (c.x+(width /2))
				var/delta_y = (owner.c.y+(owner.height/2)) - (c.y+(height/2))
				var/owner_dist = sqrt(delta_x*delta_x+delta_y*delta_y)
				var/trans_x = 0
				var/trans_y = 0
				if(owner_dist > max_dist){
					if(owner.c.x+(owner.width /2) > c.x+(width /2)){ trans_x =  speed}
					else{                trans_x = -speed}
					if(owner.c.y+(owner.height/2) > c.y+(height/2)){ trans_y =  speed}
					else{                trans_y = -speed}
					}
				translate(trans_x, trans_y)
				redraw()
				var/game/enemy/E = locate() in orange(COLLISION_RANGE, src)
				if(E){
					if(abs(E.c.x - c.x) >= abs(E.c.y - c.y)){
						if(E.c.x >= c.x){ dir = EAST }
						else{             dir = WEST }
						}
					else{
						if(E.c.y >= c.y){ dir = NORTH}
						else{             dir = SOUTH}
						}
					if((aura-skill1_cost)>=0) {
						var/game/hero/skill/new_skill = new skill1(src)
						adjust_aura(-skill1_cost)
						new_skill.activate()
						}
					}
				}
			}
		golem{
			parent_type = /game/hero/summon/archetype/normal
			width = 24
			height = 24
			max_health = 10
			max_aura = 1
			aura_rate = 40
			icon = 'large.dmi'
			icon_state = "golem"
			move_toggle = TRUE
			projectile_type = /game/hero/summon/golem/fist
			skill1_cost = 1
			skill1 = /game/hero/skill/golem_fist
			behavior(){
				if(projectiles.len){ return}
				. = ..()
				if(!projectiles.len && aura){
					var/game/enemy/E = locate() in orange(COLLISION_RANGE, src)
					if(E){
						if(abs(E.c.x - c.x) >= abs(E.c.y - c.y)){
							if(E.c.x >= c.x){ dir = EAST ; bearing =   0}
							else{             dir = WEST ; bearing = 180}
							}
						else{
							if(E.c.y >= c.y){ dir = NORTH; bearing =  90}
							else{             dir = SOUTH; bearing = 270}
							}
						if((aura-skill1_cost)>=0) {
							var/game/hero/skill/new_skill = new skill1(src)
							adjust_aura(-skill1_cost)
							new_skill.activate()
							}
						}
					}
				}

			fist{
				parent_type = /game/hero/projectile
				icon = 'large.dmi'
				sound = "sword"
				impact(var/game/map/mover/combatant/target){
					owner.attack(target, potency)
					}
				height = 5
				width  = 5
				persistent = TRUE
				potency = 3
				var{
					stage = 0
					state_name = "golem"
					}
				New(){
					. = ..()
					owner.icon_state = "[owner.icon_state]_attack"
					}
				behavior(){
					stage++
					dir = owner.dir
					switch(stage){
						if(1,2){
							return
							}
						if(3,4,11,12){
							icon_state = "[state_name]_8"
							switch(dir){
								if(NORTH, SOUTH){
									height = 8
									width  = 12
									}
								if( EAST,  WEST){
									height = 12
									width  = 8
									}
								}
							}
						if(5,6,9,10){
							icon_state = "[state_name]_16"
							switch(dir){
								if(NORTH, SOUTH){
									height = 16
									width  = 12
									}
								if( EAST,  WEST){
									height = 12
									width  = 16
									}
								}
							}
						if(7,8){
							icon_state = "[state_name]_24"
							switch(dir){
								if(NORTH, SOUTH){
									height = 24
									width  = 12
									}
								if( EAST,  WEST){
									height = 12
									width  = 24
									}
								}
							}
						if(13){
							owner.icon_state = initial(owner.icon_state)
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
			}
		skeleton{
			parent_type = /game/hero/summon/archetype/normal
			max_health = 7
			max_aura = 1
			aura_rate = 25
			icon = 'skeleton.dmi'
			move_toggle = TRUE
			skill1_cost = 1
			skill1 = /game/hero/skill/send_projectile_type
			New(){
				. = ..()
				projectile_type = pick(
					/game/hero/projectile/lance,
					/game/hero/projectile/axe,
					/game/hero/projectile/bone,
					)
				}
			behavior(){
				if(projectiles.len){ return}
				. = ..()
				if(!projectiles.len && aura){
					var/game/enemy/E = locate() in orange(COLLISION_RANGE, src)
					if(E){
						if(abs(E.c.x - c.x) >= abs(E.c.y - c.y)){
							if(E.c.x >= c.x){ dir = EAST ; bearing =   0}
							else{             dir = WEST ; bearing = 180}
							}
						else{
							if(E.c.y >= c.y){ dir = NORTH; bearing =  90}
							else{             dir = SOUTH; bearing = 270}
							}
						if((aura-skill1_cost)>=0) {
							adjust_aura(-skill1_cost)
							shoot()
							}
						}
					}
				}
			}

		genie{
			icon_state = "genie"
			max_health = 10
			max_aura = 6
			aura_rate = 30
			speed = 1
			movement = MOVEMENT_ALL
			projectile_type = /game/hero/projectile/magic_1
			skill1_cost = 1
			skill2_cost = 1
			skill3_cost = 3
			skill1 = /game/hero/skill/heal
			skill2 = /game/hero/skill/genie_fire
			skill3 = /game/hero/skill/genie_protect
			var{
				max_dist = 24
				}
			behavior(){
				. = ..()
				icon_state = initial(icon_state)
				var/delta_x = (owner.c.x+(owner.width /2)) - (c.x+(width /2))
				var/delta_y = (owner.c.y+(owner.height/2)) - (c.y+(height/2))
				var/owner_dist = sqrt(delta_x*delta_x+delta_y*delta_y)
				var/trans_x = 0
				var/trans_y = 0
				if(owner_dist > max_dist){
					if(owner.c.x+(owner.width /2) > c.x+(width /2)){ trans_x =  speed}
					else{                trans_x = -speed}
					if(owner.c.y+(owner.height/2) > c.y+(height/2)){ trans_y =  speed}
					else{                trans_y = -speed}
					}
				translate(trans_x, trans_y)
				if(aura){
					var/fire = TRUE
					for(var/game/hero/H in orange(COLLISION_RANGE-1, src)){
						if(H.health < H.max_health){
							fire = FALSE
							if((aura-skill1_cost)>=0) {
								var/game/hero/skill/new_skill = new skill1(src)
								adjust_aura(-skill1_cost)
								new_skill.activate()
								}
							}
						break
						}
					if(fire){
						if((aura-skill2_cost)>=0) {
							var/game/hero/skill/new_skill = new skill2(src)
							adjust_aura(-skill2_cost)
							new_skill.activate()
							}
						}
					}
				redraw()
				}
			New(){
				. = ..()
				spawn(){
					if((aura-skill3_cost)>=0) {
						var/game/hero/skill/new_skill = new skill3(src)
						adjust_aura(-skill3_cost)
						new_skill.activate()
						}
					}
				}
			}
		}
	}
game/hero/summon/archetype{
	normal{
		var{
			bearing = 0
			shoot_frequency = 96
			move_toggle = -1
			atomic = TRUE
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
		hurt(damage, var/game/map/mover/combatant/attacker, var/game/map/mover/projectile/proxy){
			if(!proxy){
				bearing -= 180
				}
			. = ..()
			}
		proc{
			atom_cross(){
				if(rand()*4 > 3){
					bearing += pick(90, -90, 180)
					}
				}
			}
		}
	}