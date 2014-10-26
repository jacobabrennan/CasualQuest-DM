game/hero/subscriber/d4rk354b3r{
	name="D4RK3 54B3R"
	icon = 'd4rk354b3r.dmi'
	max_health = 6
	max_aura = 4
	aura_rate = 80
	projectile_type = /game/hero/projectile/wood_sword
	skill1_cost = 1
	skill2_cost = 4
	skill3_cost = 4
	skill1 = /game/hero/skill/d5bolt
	skill2 = /game/hero/skill/d5barrier_encircle
	skill3 = /game/hero/skill/d5combat_potential
	/*
	barrier_orb{
		parent_type = /game/hero/projectile/controlled_orb
		icon_state = "barrier"
		finish(){
			var/game/hero/closest
			var/close_distance = -1
			for(var/game/hero/H in orange(COLLISION_RANGE, src)){
				if(!closest){ closest = H; continue}
				var/h_dist = abs((H.c.x+(H.width/2)) - (c.x+(width/2))) + abs((H.c.y+(H.height/2)) - (c.y+(height/2)))
				if(h_dist < close_distance){
					closest = H
					}
				}
			if(closest){
				if(collision_check(closest)){
					new /game/hero/projectile/barrier(closest)
					}
				}
			if(istype(owner) && istype(owner.player)){
				owner.player.clear_keys()
				}
			owner.icon_state = initial(owner.icon_state)
			Del()
			}
		}*/
	barrier_encircle{
		parent_type = /game/hero/projectile
		icon = 'd4rk354b3r_large.dmi'
		icon_state = "orb"
		persistent = TRUE
		potency = 0
		width = 0
		height = 0
		x_offset = -8
		y_offset = -8
		var{
			angle = 0
			radius = 24
			theta_offset = 0
			}
		impact(){}
		behavior(){
			. = ..()
			angle += 15
			if(angle >= 360){ Del()}
			c.x = (owner.c.x+(owner.width /2)) + cos(angle+theta_offset)*radius
			c.y = (owner.c.y+(owner.height/2)) + sin(angle+theta_offset)*radius
			}
		}
	barrier{
		parent_type = /game/hero/projectile
		icon = 'd4rk354b3r_large.dmi'
		icon_state = "barrier"
		persistent = TRUE
		impact(){}
		potency = 1
		height = 24
		width  = 24
		var{
			hits = 3
			}
		behavior(){
			c.x = (owner.c.x+(owner.width /2))-(width /2)
			c.y = (owner.c.y+(owner.height/2))-(height/2)
			var/defended = FALSE
			for(var/game/enemy/E in orange(COLLISION_RANGE,src)){
				if(E.invulnerable){ continue}
				if(!collision_check(E)){ continue}
				//var/delta_x = abs((P.c.x+(P.width /2)) - (c.x+(width /2)))
				//var/delta_y = abs((P.c.y+(P.height/2)) - (c.y+(height/2)))
				//var/c_range = sqrt((delta_x*delta_x)+(delta_y*delta_y))
				//if(c_range > radius){ continue}
				defended = TRUE
				owner.attack(E, potency)
				if(E){
					E.intelligence = new /game/map/mover/intelligence/freezer(32)
					}
				}
			if(defended){
				hits--
				if(hits <= 0){
					Del()
					}
				}
			}
		}
	chain{
		parent_type = /game/hero/projectile
		icon = 'd4rk354b3r_large.dmi'
		icon_state = "chain"
		width = 14
		height = 14
		persistent = TRUE
		potency = 1
		max_time = 12
		var{
			game/map/mover/combatant/target
			target_time = 12
			chained = FALSE
			}
		New(var/_owner, var/game/map/mover/combatant/_target){
			. = ..()
			target = _target
			c.x = (owner.c.x+(owner.width /2))-(width /2)
			c.y = (owner.c.y+(owner.height/2))-(height/2)
			}
		behavior(){
			if(!target){
				if(chained){ Del()}
				retarget()
				return
				}
			if(target_time <= 0){
				owner.attack(target, potency, src)
				if(!chained){
					retarget()
					}
				else{
					Del()
					}
				}
			if(!target){ Del()}
			var/d_x = (target.c.x+(target.width /2)) - (c.x+(width /2))
			var/d_y = (target.c.y+(target.height/2)) - (c.y+(height/2))
			if(d_x <= 3 && d_y <= 3){
				target_time = 1
				}
			translate(d_x/target_time, d_y/target_time)
			target_time--
			}
		proc{
			retarget(){
				var/list/targets = new()
				var/max_dist = 64
				for(var/game/map/mover/combatant/potential in orange(COLLISION_RANGE, src)){
					var/d_x = abs((c.x+(width /2)) - (potential.c.x+(potential.width /2)))-potential.width /2
					var/d_y = abs((c.y+(height/2)) - (potential.c.y+(potential.height/2)))-potential.height/2
					var/dist = sqrt(d_x*d_x + d_y*d_y)
					if(dist < max_dist){
						targets.Add(potential)
						}
					}
				if(!targets.len){ Del()}
				target = pick(targets)
				target_time = 12
				chained = pick(TRUE, FALSE)
				}
			}
		}
	bolt{
		parent_type = /game/hero/projectile
		icon = 'd4rk354b3r_large.dmi'
		icon_state = "bolt"
		width = 16
		height = 16
		persistent = TRUE
		potency = 1
		max_time = 10
		New(var/game/hero/subscriber/d4rk354b3r/caster, which=0){
			. = ..()
			dir = owner.dir
			switch(owner.dir){
				if(NORTH){
					c.x = owner.c.x + (owner.width -width )/2
					c.y = owner.c.y +  owner.height + height*which
					}
				if(SOUTH){
					c.x = owner.c.x + (owner.width -width )/2
					c.y = owner.c.y -  owner.height - height*which
					}
				if(EAST ){
					c.x = owner.c.x +  owner.width  + width *which
					c.y = owner.c.y + (owner.height-height)/2
					}
				if(WEST ){
					c.x = owner.c.x -  owner.width  - width *which
					c.y = owner.c.y + (owner.height-height)/2
					}
				}
			}
		}
	}