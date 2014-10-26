game/hero/subscriber/cauti0n{
	name = "CauTi0N"
	icon = 'cauti0N.dmi'
	max_aura = 3
	aura_rate = 75
	max_health = 11
	speed = 2
	width = 16
	height = 16
	projectile_type = /game/hero/projectile/axe
	skill1_cost = 1
	skill2_cost = 3
	skill3_cost = 3
	skill1 = /game/hero/skill/heal
	skill2 = /game/hero/skill/summon_skeleton
	skill3 = /game/hero/skill/jump_attack
	adjust_aura(amo){
		if(dash){
			if(amo > 0){ return}
			else{
				. = ..()
				if(aura <= 0){
					dash = FALSE
					reverseDamage = 0
					projectile_type = initial(projectile_type)
					icon = initial(icon)
					icon_state = initial(icon_state)
					height = initial(height)
					movement = initial(movement)
					speed = initial(speed)
					}
				}
			return
			}
		. = ..()
		}
	take_turn(){
		. = ..()
		if(endwave) {
			height = initial(width)
			projectile_type = initial(projectile_type)
			icon = initial(icon)
			icon_state = initial(icon_state)
			dash = FALSE
			reverseDamage = 0
			movement = initial(movement)
			speed = initial(speed)}
		if(dash){
			adjust_aura(-4)
			speed++
			}
		}



	jump_shadow{
		parent_type = /game/hero/projectile/controlled_orb
		icon = 'cauti0N.dmi'
		icon_state = "shadow"
		var{
			direction = 1
			jump_time
			total_time = 0
			}
		intelligence(var/game/hero/subscriber/cauti0n/cauti0n){
			. = ..()
			cauti0n.icon_state = "jumper"
			cauti0n.invulnerable = 3
			cauti0n.invincible = TRUE
			cauti0n.c.x = c.x
			cauti0n.c.y = c.y
			cauti0n.dir = dir
			var waveCurrent = game.map.wave
			jump_time += direction
			total_time++
			if(jump_time >= 32){
				direction = -1
				}
			cauti0n.y_offset = -80*(((total_time-32)/32)*((total_time-32)/32))+80
			spawn(60) {
				if(waveCurrent != game.map.wave) {
					land(cauti0n,"ENDWAVE")
					return
					}
				}
			if(jump_time <= 0){
				land(cauti0n)
				}
			}
		finish(){}
		proc{
			land(var/game/hero/subscriber/cauti0n/cauti0n,var/flag){
				cauti0n.invincible = FALSE
				cauti0n.y_offset = 0
				cauti0n.icon_state = initial(cauti0n.icon_state)
				for(var/game/enemy/E in orange(COLLISION_RANGE, cauti0n)){
					if(cauti0n.collision_check(E)){
						cauti0n.attack(E, 2)
						}
					}
				if(!flag) {
					explode() }
				Del()
				}
			}
		explode(){
			for(var/angle in list(0, 60, 120, 180, 240, 300)){
				var/game/hero/projectile/wind/wind = new(owner)
				wind.vel.x = cos(angle)*4
				wind.vel.y = sin(angle)*4
				wind.max_range = 24
				}
			}
		}
	}