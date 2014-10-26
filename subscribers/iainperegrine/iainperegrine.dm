game/hero {
	var {
		meditate = FALSE
		regen = 400
		}
	}
game/hero/custom/iainperegrine{
	icon = 'iainperegrine.dmi'
	max_health = 7
	max_aura = 10
	aura_rate = 150
	movement = MOVEMENT_LAND | MOVEMENT_WATER
	projectile_type = /game/hero/projectile/wood_sword
	skill1_cost = 1
	skill2_cost = 1
	skill3_cost = 0
	skill1 = /game/hero/custom/iainperegrine/heal_cherry
	skill2 = /game/hero/custom/iainperegrine/mana_heal
	skill3 = /game/hero/skill/life
	hurt(){
		if(meditate){ return}
		. = ..()
		}
	px_move(){
		if(meditate){ return}
		. = ..()
		}
	call_help(){
		if(meditate){ return}
		. = ..()
		}
	behavior(){
		. = ..()
		if(!meditate && (--regen <= 0)){
			regen = initial(regen)
			adjust_health(1)
			}
		}
	heal_cherry {
		parent_type = /game/hero/skill
		name = "Cherry Heal"
		description = {"Heals ~p health of surrounding party members by hurling out cherries in various directions."}
		potency = 1
		activate(){
			owner.icon_state = "cast"
			owner.cast_time(9)
			var/heal_range = 32
			for(var/I = 1 to 8){
				var/game/hero/projectile/healing/H = new(owner)
				H.icon = 'items.dmi'
				H.icon_state = "cherry"
				H.width = 8
				H.height = 8
				H.max_range = 0
				H.max_time = 10
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				var/angle = (I-1)*(360/8)
				H.vel.x = cos(angle)*4
				H.vel.y = sin(angle)*4
				}
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					if(H != owner){
						H.adjust_health(potency, owner)
						H.invulnerable = max(H.invulnerable, 6)
						}
					}
				}
			}
		}
	mana_heal {
		parent_type = /game/hero/skill
		name = "Mana Regenerate"
		description = {"Regenerates mana of nearby party members."}
		activate(){
			owner.time_out(64)
			owner.icon_state = "meditate"
			var/heal_range = 32
			for(var/I = 1 to 8){
				var/game/hero/projectile/healing/H = new(owner)
				H.icon = 'items.dmi'
				H.icon_state = "bottle"
				H.width = 8
				H.height = 8
				H.max_range = 0
				H.max_time = 10
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				var/angle = (I-1)*(360/8)
				H.vel.x = cos(angle)*4
				H.vel.y = sin(angle)*4
				}
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					if(H != owner){
						H.adjust_aura(1)
						}
					}
				}
			}
		}
	/*skill3(){
		if(meditate){
			meditate = FALSE
			icon_state = null
			}
		else if(!meditate){
			icon_state = "meditate"
			meditate = TRUE
			}
		}*/
	}
game/hero/subscriber/iainperegrine{
	parent_type = /game/hero/custom/iainperegrine
	/*
	icon = 'iainperegrine.dmi'
	max_health = 7
	max_aura = 10
	aura_rate = 150
	movement = MOVEMENT_LAND | MOVEMENT_WATER
	projectile_type = /game/hero/projectile/wood_sword
	skill1_cost = 1
	skill2_cost = 1
	skill3_cost = 6
	skill1 = /game/hero/skill/heal_cherry
	skill2 = /game/hero/skill/mana_heal
	skill3 = /game/hero/skill/life
	hurt(){
		if(meditate){ return}
		. = ..()
		}
	px_move(){
		if(meditate){ return}
		. = ..()
		}
	call_help(){
		if(meditate){ return}
		. = ..()
		}
	behavior(){
		. = ..()
		if(!meditate && (--regen <= 0)){
			regen = initial(regen)
			adjust_health(1)
			}
		}
	/*skill3(){
		if(meditate){
			meditate = FALSE
			icon_state = null
			}
		else if(!meditate){
			icon_state = "meditate"
			meditate = TRUE
			}
		}*/*/
	}