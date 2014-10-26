game/hero/subscriber/jamckell{
	icon = 'jamckell.dmi'
	level_knight = 0
	level_rogue = 0
	max_health = 8
	max_aura = 2
	speed = 2
	aura_rate = 198
	projectile_type = /game/hero/projectile/wood_sword
	skill1_cost = 1
	skill2_cost = 2
	skill3_cost = 1
	skill1 = /game/hero/skill/javelin
	skill2 = /game/hero/skill/javelin_spin
	skill3 = /game/hero/skill/jump_attack
	shoot(){
		if(projectile){ return}
		if(javelin){
			return ..()
			}
		icon_state = "attack"
		intelligence = new /game/map/mover/intelligence/freezer(6)
		javelin = new /game/hero/subscriber/jamckell/javelin(src)
		}


	jump_shadow{
		parent_type = /game/hero/projectile/controlled_orb
		icon = 'jamckell.dmi'
		icon_state = "shadow"
		var{
			direction = 1
			jump_time
			total_time = 0
			}
		intelligence(var/game/hero/subscriber/jamckell/jamckell){
			. = ..()
			jamckell.icon_state = "jumper"
			jamckell.invulnerable = 3
			jamckell.invincible = TRUE
			jamckell.c.x = c.x
			jamckell.c.y = c.y
			jamckell.dir = dir
			jump_time += direction
			total_time++
			if(jump_time >= 32){
				direction = -1
				}
			jamckell.y_offset = -80*(((total_time-32)/32)*((total_time-32)/32))+80
			if(jump_time <= 0){
				land(jamckell)
				}
			}
		finish(){}
		proc{
			land(var/game/hero/subscriber/jamckell/jamckell){
				jamckell.invincible = FALSE
				jamckell.y_offset = 0
				jamckell.icon_state = initial(jamckell.icon_state)
				for(var/game/enemy/E in orange(COLLISION_RANGE, jamckell)){
					if(jamckell.collision_check(E)){
						jamckell.attack(E, 2)

						}
					}
				explode()
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
	javelin{
		parent_type = /game/hero/projectile/arrow
		potency = 2
		icon = 'jamckell.dmi'
		icon_state = "javelin"
		max_range = 0
		max_time = 0
		long_width = 32
		short_width = 5
		movement = MOVEMENT_ALL
		max_range = 2000
		impact(var/game/map/mover/combatant/target){
			land()
			. = ..()
			}
		horizontal_stop(){
			land()
			. = ..()
			}
		vertical_stop(){
			land()
			. = ..()
			}
		behavior(){
			current_time++
			if(current_time == 6){ owner.icon_state = initial(owner.icon_state)}
			. = ..()
			}
		proc{
			land(){
				if(current_time <= 6){ owner.icon_state = initial(owner.icon_state)}
				var/game/hero/subscriber/jamckell/jamckell = owner
				if(istype(jamckell)){
					var/game/hero/subscriber/jamckell/javelin_item/jav = new(null, src)
					jamckell.javelin = jav
					jav.jamckell = jamckell
					}
				}
			}
		}
	javelin_item{
		parent_type = /game/item
		icon = 'jamckell.dmi'
		icon_state = "javelin_flash"
		var{
			game/hero/subscriber/jamckell/jamckell
			}
		New(var/game/map/mover/combatant/dead, var/game/hero/subscriber/jamckell/javelin/impactor){
			. = ..()
			c.x = impactor.c.x
			c.y = impactor.c.y
			width = impactor.width
			height = impactor.height
			dir = impactor.dir
			}
		activate(var/game/hero/hero){
			if(hero != jamckell){
				return
				}
			del src
			}
		}
	jav_spin{
		parent_type = /game/hero/projectile/sword
		icon = 'jamckell.dmi'
		icon_state = "jav_spin"
		height = 10
		width  = 10
		persistent = TRUE
		potency = 2
		state_name = "jav_spin"
		sound = "axe"
		redraw(){}
		behavior(){
			stage++
			owner.icon_state = "attack"
			loc = owner.loc
			switch(stage){
				if( 1, 2){ dir =      owner.dir      ; owner.dir = dir}
				if( 3, 4){ dir = turn(owner.dir,  45); owner.dir = dir}
				if( 5, 6){ dir = turn(owner.dir,  45); owner.dir = dir}
				if( 7, 8){ dir = turn(owner.dir,  45); owner.dir = dir}
				if( 9,10){ dir = turn(owner.dir,  45); owner.dir = dir}
				if(11,12){ dir = turn(owner.dir,  45); owner.dir = dir}
				if(13,14){ dir = turn(owner.dir,  45); owner.dir = dir}
				if(15,16){ dir = turn(owner.dir,  45); owner.dir = dir}
				if(17,18){ dir = turn(owner.dir,  45); owner.dir = dir}
				if(19){
					owner.icon_state = initial(owner.icon_state)
					del src
					}
				}
			switch(dir){
				if(EAST     ){
					c.x = owner.c.x+(16+6)
					c.y = owner.c.y    +2
					pixel_x = owner.pixel_x+16
					pixel_y = owner.pixel_y
					}
				if(SOUTHEAST){
					c.x = owner.c.x+(16+3)
					c.y = owner.c.y-(16+3)
					pixel_x = owner.pixel_x+13
					pixel_y = owner.pixel_y-13
					}
				if(SOUTH    ){
					c.x = owner.c.x+2
					c.y = owner.c.y-(16+6)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y-16
					}
				if(SOUTHWEST){
					c.x = owner.c.x-(16+3)
					c.y = owner.c.y-(16+3)
					pixel_x = owner.pixel_x-13
					pixel_y = owner.pixel_y-13
					}
				if(WEST     ){
					c.x = owner.c.x-(16+6)
					c.y = owner.c.y    +2
					pixel_x = owner.pixel_x-16
					pixel_y = owner.pixel_y
					}
				if(NORTHWEST){
					c.x = owner.c.x-(16+3)
					c.y = owner.c.y+ 16+3
					pixel_x = owner.pixel_x-13
					pixel_y = owner.pixel_y+13
					}
				if(NORTH    ){
					c.x = owner.c.x+2
					c.y = owner.c.y+(16+6)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y+16
					}
				if(NORTHEAST){
					c.x = owner.c.x+(16+3)
					c.y = owner.c.y+(16+3)
					pixel_x = owner.pixel_x+13
					pixel_y = owner.pixel_y+13
					}
				}
			}
		}
	}