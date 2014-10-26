game/hero {
	var{
		armor = 0
		}
	proc{
		armor_on(){
			armor = 170
			speed = 1
			icon = 'dooney2.dmi'
			}
		armor_off(){
			icon = 'dooney1.dmi'
			speed = 2
			invulnerable = 16
			}
		}
	}
game/hero/custom/dooney1{
	icon = 'dooney1.dmi'
	max_health = 8
	max_aura = 6
	aura_rate = 175
	speed = 2
	projectile_type = /game/hero/projectile/fist
	skill1_cost = 2
	skill2_cost = 3
	skill3_cost = 4
	skill1 = /game/hero/skill/boulder_push
	skill2 = /game/hero/skill/earth_wall
	skill3 = /game/hero/skill/earth_armor

	take_turn(){
		. = ..()
		if(armor){
			armor--
			invulnerable = 3
			if(!armor){
				armor_off()
				}
			}
		}
	earth{
		parent_type = /game/map/mover/projectile/magic_1
		potency = 1
		speed = 4
		width = 14
		height = 14
		x_offset = -1
		y_offset = -1
		movement = MOVEMENT_LAND
		persistent = TRUE
		icon = 'dooney1.dmi'
		icon_state = "boulder"
		}
	wall{
		parent_type = /game/map/mover/projectile/magic_1
		potency = 0
		speed = 8
		width = 16
		height = 16
		movement = MOVEMENT_LAND
		persistent = TRUE
		icon = 'dooney1.dmi'
		icon_state = "wall"
		max_time = 256
		impact(){}
		horizontal_stop(){}
		vertical_stop(){}
		behavior(){
			. = ..()
			vel.x -= sign(vel.x)
			vel.y -= sign(vel.y)
			for(var/game/map/mover/projectile/P in orange(COLLISION_RANGE,src)){
				if(P.persistent){ continue}
				if(!collision_check(P)){ continue}
				if(!istype(P.owner, /game/hero)){
					P.Del()
					}
				}
			for(var/game/enemy/E in orange(COLLISION_RANGE,src)){
				if(E.invulnerable){ continue}
				if(!collision_check(E)){ continue}
				owner.attack(E, 0)
				}
			}
		}
	barrier{
		parent_type = /game/hero/projectile
		icon = 'dooney1_large.dmi'
		icon_state = "barrier"
		persistent = TRUE
		potency = 0
		width = 0
		height = 0
		x_offset = -12
		y_offset = -12
		max_time = 16
		behavior(){
			. = ..()
			c.x = owner.c.x + owner.width/2
			c.y = owner.c.y + owner.height/2
			}
		}
	}