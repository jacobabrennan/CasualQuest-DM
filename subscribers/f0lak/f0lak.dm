game/hero {
	var {
		ael = FALSE
		specialtype = null
		}
	}
game/hero/subscriber/kai{
	parent_type = /game/hero/subscriber/f0lak
	}
game/hero/subscriber/f0lak{
	icon = '_hazordhu.dmi'
	specialtype="f0lak"
	level_knight = 0
	level_rogue = 0
	projectile_type = /game/hero/projectile/axe
	max_aura = 256
	aura_rate = 1
	max_health = 8
	skill1_cost = 0
	skill2_cost = 64
	skill3_cost = 100
	skill1 = /game/hero/skill/ghost_mode
	skill2 = /game/hero/skill/heal
	skill3 = /game/hero/skill/f0transform

	adjust_aura(amo){
		if(ael){
			if(amo > 0){ return}
			else{
				. = ..()
				if(aura <= 0){
					ael = FALSE
					projectile_type = initial(projectile_type)
					icon = initial(icon)
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
		if(ael){
			adjust_aura(-1)
			}
		}
	transformer{
		parent_type = /game/hero/projectile/magic_1
		icon = 'projectiles.dmi'
		icon_state = "magic_2"
		height = 5
		width  = 5
		persistent = FALSE
		potency = 3
		sound = "magic"
		impact(var/game/enemy/target){
			if(target.health > potency){
				. = ..()
				}
			else{
				var/game/hero/subscriber/f0lak/sty/sty = new(owner)
				sty.c.x = target.c.x + (target.width  - sty.width )/2
				sty.c.y = target.c.y + (target.height - sty.height)/2
				. = ..()
				if(target){
					del target
					}
				}
			}
		}
	sty{
		parent_type = /game/hero/projectile
		icon = 'f0lak.dmi'
		icon_state = "sty"
		persistent = TRUE
		impact(){}
		horizontal_stop(){
			dir = pick(NORTH, SOUTH, EAST, WEST)
			}
		vertical_stop(){
			dir = pick(NORTH, SOUTH, EAST, WEST)
			}
		movement = MOVEMENT_LAND
		width = 8
		height = 8
		New(){
			. = ..()
			dir = pick(NORTH, SOUTH, EAST, WEST)
			}
		var{
			eating = FALSE
			}
		behavior(){
			if(eating > 0){
				eating--
				return
				}
			if(rand()*128 > 127){
				eating = 64
				return
				}
			if(pick(0,0,1)){
				switch(dir){
					if(NORTH){ translate( 0, 1)}
					if(SOUTH){ translate( 0,-1)}
					if(EAST ){ translate( 1, 0)}
					if(WEST ){ translate(-1, 0)}
					}
				}
			if(rand()*128 > 127){
				dir = pick(NORTH, SOUTH, EAST, WEST)
				}
			}
		}
	}