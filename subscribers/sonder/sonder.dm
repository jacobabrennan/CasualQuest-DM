game/hero/subscriber/sonder{
	icon = 'sonder.dmi'
	level_knight = 0
	level_rogue = 0
	max_health = 7
	max_aura = 5
	projectile_type = /game/hero/projectile/wood_sword
	skill2_cost = 2
	skill3_cost = 3
	skill1 = /game/hero/skill/sonder_grapple
	skill2 = /game/hero/skill/heal_orb
	skill3 = /game/hero/skill/barrier_orb
	grapple{
		parent_type = /game/hero/projectile
		persistent = TRUE
		potency = 1
		icon = 'projectiles.dmi'
		icon_state = "hook"
		width = 13
		height = 13
		movement = MOVEMENT_LAND | MOVEMENT_WATER
		var{
			game/hero/subscriber/sonder/grapple/chain/chain1
			game/hero/subscriber/sonder/grapple/chain/chain2
			game/hero/subscriber/sonder/grapple/chain/chain3
			}
		New(){
			. = ..()
			c.x = owner.c.x + (owner.width -width )/2
			c.y = owner.c.y + (owner.height-height)/2
			chain1 = new(owner)
			chain2 = new(owner)
			chain3 = new(owner)
			layer++
			dir = owner.dir
			switch(owner.dir){
				if(EAST ){ vel.x =  6; vel.y =  0}
				if(WEST ){ vel.x = -6; vel.y =  0}
				if(NORTH){ vel.x =  0; vel.y =  6}
				if(SOUTH){ vel.x =  0; vel.y = -6}
				}
			}
		max_range = 2000
		behavior(){
			owner.icon_state = "attack"
			if(!reversed){ time++}
			else{          time--}
			if(!time){ del src}
			if(!stuck){
				. = ..()
				}
			else{
				var/coord/old_c = owner.c.Copy()
				owner.translate(-vel.x, -vel.y)
				if(old_c.x == owner.c.x && old_c.y == owner.c.y){
					stuck = FALSE
					}
				}
			var/owner_center
			var/factor
			if(dir & (EAST|WEST)){
				chain1.c.y = owner.c.y + (owner.height-chain1.height)/2
				chain2.c.y = chain1.c.y
				chain3.c.y = chain1.c.y
				owner_center = owner.c.x+(owner.width/2)
				factor = (c.x+(width /2)) - owner_center
				chain1.c.x = (owner_center + factor*1/4) - width /2
				chain2.c.x = (owner_center + factor*2/4) - width /2
				chain3.c.x = (owner_center + factor*3/4) - width /2
				}
			if(dir & (NORTH|SOUTH)){
				chain1.c.x = owner.c.x + (owner.width-chain1.width)/2
				chain2.c.x = chain1.c.x
				chain3.c.x = chain1.c.x
				owner_center = owner.c.y+(owner.height/2)
				factor = (c.y+(height/2)) - owner_center
				chain1.c.y = (owner_center + factor*1/4) - height/2
				chain2.c.y = (owner_center + factor*2/4) - height/2
				chain3.c.y = (owner_center + factor*3/4) - height/2
				}
			}
		impact(var/game/map/mover/combatant/target){
			if(reversed){ return}
			//owner.attack(target, potency)
			target.intelligence = src
			reverse()
			}
		horizontal_stop(){
			reverse()
			stuck = TRUE
			}
		vertical_stop(){
			reverse()
			stuck = TRUE
			}
		var{
			reversed = FALSE
			time = 0
			stuck = FALSE
			}
		proc{
			reverse(){
				if(reversed){ return}
				reversed = TRUE
				vel.x *= -1
				vel.y *= -1
				}
			intelligence(var/game/map/mover/hostage){
				if(time < 3){ return}
				var/coord/old_c = hostage.c.Copy()
				hostage.translate(vel.x, vel.y)
				if(old_c.x == hostage.c.x && old_c.y == hostage.c.y){
					stuck = TRUE
					return
					}
				else{
					stuck = FALSE
					}
				}
			}
		Del(){
			del chain1
			del chain2
			del chain3
			owner.icon_state = null
			. = ..()
			}
		chain{
			parent_type = /game/hero/projectile
			icon = 'projectiles.dmi'
			icon_state = "chain"
			persistent = TRUE
			potency = 0
			width = 5
			height = 5
			impact(){}
			behavior(){}
			}
		}
	}