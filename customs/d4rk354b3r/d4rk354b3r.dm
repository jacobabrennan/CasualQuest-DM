// bikerosa@cox.net
game/hero {
	var{
		game/hero/custom/d4rk354b3r/falcon/falcon
		falcon_wave
		}
	}
game/hero/custom/d4rk354b3r{
	name="Falconer"
	icon = 'd4rk354b3r_falconer.dmi'
	max_health = 8
	max_aura = 6
	aura_rate = 125
	projectile_type = /game/hero/projectile/wood_lance
	skill2_cost = 3
	skill1 = /game/hero/skill/falco_wave
	skill2 = /game/hero/skill/d5target
	skill3 = /game/hero/skill/proj_arrow

	falcon{
		parent_type = /game/hero/summon
		trapable = FALSE
		movement = MOVEMENT_ALL
		icon = 'd4rk354b3r_falcon.dmi'
		icon_state = "falcon_1"
		dir = SOUTHEAST
		max_aura = 1
		aura_rate = 150
		y_offset = 8
		x_offset = -3
		width  = 10
		height = 10
		spam_attack_block = TRUE
		var{
			game/enemy/target
			game/hero/custom/d4rk354b3r/falcon/shadow/shadow
			stage = 0
			size = 1
			}
		behavior(){
			if(!owner){ del src; return}
			var/trans_x = 0
			var/trans_y = 0
			var/new_dir = 0
			if(target == owner){
				invulnerable = pick(1,2,3,4,5)
				if(abs((owner.c.x+owner.width/2) - (c.x+width/2)) > 16){
					if(owner.c.x > c.x){
						new_dir |= EAST
						trans_x += 3
						}
					else if(owner.c.x < c.x){
						new_dir |= WEST
						trans_x -= 3
						}
					}
				if(abs((owner.c.y+owner.height/2) - (c.y+height/2)) > 16){
					if(owner.c.y > c.y){
						new_dir |= NORTH
						trans_y += 3
						}
					else if(owner.c.y < c.y){
						new_dir |= SOUTH
						trans_y -= 3
						}
					}
				if(!new_dir){ target = null}
				else{ dir = new_dir}
				}
			else if(target && !stage){
				stage = 1
				}
			else if(stage == 1){
				invulnerable = 8
				if(y_offset < 256){
					y_offset += 8
					}
				else{
					stage = 2
					if(!target){ target = pick(game.map.enemies)}
					new_dir = 0
					if(target){
						if(target.c.x >= c.x){ new_dir |= EAST } else{ new_dir |= WEST }
						if(target.c.y >= c.y){ new_dir |= NORTH} else{ new_dir |= SOUTH}
						}
					dir = new_dir
					icon_state = "fall"
					}
				}
			else if(stage == 2){
				invulnerable = 8
				y_offset -= 16
				if(!target){
					if(!target){ target = pick(game.map.enemies)}
					}
				else{
					trans_x += (target.c.x - c.x)/(y_offset/16)
					trans_y += (target.c.y - c.y)/(y_offset/16)
					}
				if(y_offset <= 16){
					y_offset = 8
					stage = 3
					icon_state = "falcon_[size]"
					}
				}
			else if(stage == 3){
				stage = 4
				for(var/game/enemy/E in range(COLLISION_RANGE, src)){
					if(collision_check(E)){
						attack(E, size)
						}
					}
				trans_x += sign(owner.c.x - c.x)*3
				trans_y += sign(owner.c.y - c.y)*3
				invulnerable = INVULNERABLE_TIME
				}
			else if(stage == 4){
				if(invulnerable && target){
					new_dir = 0
					if(owner.c.x < c.x){
						new_dir |= WEST
						trans_x -= 2
						}
					else{
						new_dir |= EAST
						trans_x += 2
						}
					if(owner.c.y < c.y){
						new_dir |= SOUTH
						trans_y -= 2
						}
					else{
						new_dir |= NORTH
						trans_y += 2
						}
					dir = new_dir
					}
				else{
					target = null
					stage = 0
					}
				}
			else if(aura >= 1){
				var/list/targets = new()
				for(var/game/enemy/E in range(COLLISION_RANGE, src)){
					targets.Add(E)
					}
				if(targets.len){
					adjust_aura(-1)
					target = pick(targets)
					stage = 1
					icon_state = "rise"
					}
				}
			translate(trans_x, trans_y)
			redraw()
			}
		redraw(){
			. = ..()
			shadow.c.x = c.x + x_offset// + width/2
			shadow.c.y = c.y
			shadow.redraw()
			}
		New(){
			. = ..()
			shadow = new()
			}
		die(){
			if(owner && !health){
				var/game/hero/custom/d4rk354b3r/D4 = owner
				D4.falcon_wave--;
				if(D4.falcon_wave < 0){
					D4.falcon_wave = 0
					}
				}
			. = ..()
			}
		Del(){
			del shadow
			. = ..()
			}
		proc{
			callback(){
				if(target){ return}
				target = owner
				}
			}
		shadow{
			parent_type = /game/map/mover
			icon = 'd4rk354b3r_falcon.dmi'
			icon_state = "shadow"
			width = 0
			height = 0
			//x_offset = -8
			}
		}
	target{
		parent_type = /game/hero/projectile/controlled_orb
		icon = 'd4rk354b3r_falcon.dmi'
		icon_state = "target"
		speed = 4
		finish(){
			var/game/hero/custom/d4rk354b3r/d4 = owner
			icon_state = "shadow"
			if(d4.falcon){
				var/game/enemy/closest
				var/close_distance = -1
				for(var/game/enemy/E in orange(COLLISION_RANGE, src)){
					if(!closest){ closest = E; continue}
					var/h_dist = abs((E.c.x+(E.width/2)) - (c.x+(width/2))) + abs((E.c.y+(E.height/2)) - (c.y+(height/2)))
					if(h_dist < close_distance){
						closest = E
						}
					}
				if(closest){
					if(collision_check(closest)){
						d4.falcon.target = closest
						}
					}
				}
			if(istype(owner) && istype(owner.player)){
				owner.player.clear_keys()
				}
			owner.icon_state = initial(owner.icon_state)
			Del()
			}
		}
	}