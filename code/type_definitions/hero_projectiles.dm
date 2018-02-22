

//-- Hero Projectile Type Defs -------------------------------------------------

game/hero/projectile{
	parent_type = /game/map/mover/projectile
	wood_sword{
		parent_type = /game/hero/projectile/sword
		state_name = "wood"
		potency = 1
		}
	sword{
		icon = 'projectiles.dmi'
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency)
			}
		height = 4
		width  = 4
		persistent = TRUE
		potency = 2
		sound = "sword"
		var{
			stage = 0
			state_name = "sword"
			}
		behavior(){
			stage++
			dir = owner.dir
			owner.icon_state = "attack"
			switch(stage){
				if(1,5){
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
				if(2,4){
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
				if(3){
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
				if(6){
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
	gold_sword{
		parent_type = /game/hero/projectile/sword
		state_name = "gold"
		potency = 4
		}
	black_sword{
		parent_type = /game/hero/projectile/sword
		state_name = "black"
		description = "(~p). Enemies take double damage when attacked from behind."
		impact(var/game/map/mover/combatant/target){
			if(dir_to(owner, target) == turn(target.dir,180)){
				owner.attack(target, potency*2, src)
				}
			else{
				owner.attack(target, potency, src)
				}
			}
		}
	black_knife{
		parent_type = /game/hero/projectile/black_sword
		behavior(){
			stage++
			dir = owner.dir
			owner.icon_state = "attack"
			switch(stage){
				if(1,3){
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
				if(2){
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
				if(4){
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
		}
	saber{
		parent_type = /game/hero/projectile/axe
		icon_state = "saber"
		potency = 1
		state_name = "saber"
		}
	wood_axe{
		parent_type = /game/hero/projectile/saber
		icon_state = "wood_axe"
		potency = 1
		state_name = "axe"
		}
	gold_axe{
		parent_type = /game/hero/projectile/axe
		icon_state = "gold_axe"
		potency = 3
		state_name = "axe"
		}
	axe{
		parent_type = /game/hero/projectile/sword
		icon_state = "axe"
		height = 16
		width  = 16
		persistent = TRUE
		potency = 2
		state_name = "axe"
		sound = "axe"
		description = "(~p). Sweeps in an arc in front of the character."
		redraw(){}
		behavior(){
			stage++
			owner.icon_state = "attack"
			loc = owner.loc
			switch(stage){
				if(1,2){ dir = turn(owner.dir, -45)}
				if(3,4){ dir =      owner.dir      }
				if(5,6){ dir = turn(owner.dir,  45)}
				if(7){
					owner.icon_state = initial(owner.icon_state)
					del src
					}
				}
			switch(dir){
				if(EAST     ){
					c.x = owner.c.x+(16)
					c.y = owner.c.y
					pixel_x = owner.pixel_x+16
					pixel_y = owner.pixel_y
					}
				if(SOUTHEAST){
					c.x = owner.c.x+(16)
					c.y = owner.c.y-(16)
					pixel_x = owner.pixel_x+13
					pixel_y = owner.pixel_y-13
					}
				if(SOUTH    ){
					c.x = owner.c.x+2
					c.y = owner.c.y-(16)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y-16
					}
				if(SOUTHWEST){
					c.x = owner.c.x-(16)
					c.y = owner.c.y-(16)
					pixel_x = owner.pixel_x-13
					pixel_y = owner.pixel_y-13
					}
				if(WEST     ){
					c.x = owner.c.x-(16)
					c.y = owner.c.y
					pixel_x = owner.pixel_x-16
					pixel_y = owner.pixel_y
					}
				if(NORTHWEST){
					c.x = owner.c.x-(16)
					c.y = owner.c.y+ 16
					pixel_x = owner.pixel_x-13
					pixel_y = owner.pixel_y+13
					}
				if(NORTH    ){
					c.x = owner.c.x+2
					c.y = owner.c.y+(16)
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y+16
					}
				if(NORTHEAST){
					c.x = owner.c.x+(16)
					c.y = owner.c.y+(16)
					pixel_x = owner.pixel_x+13
					pixel_y = owner.pixel_y+13
					}
				}
			redraw()
			}
		}
	wood_lance{
		parent_type = /game/hero/projectile/lance
		potency = 1
		icon = 'projectiles.dmi'
		icon_state = "wood_lance"
		}
	lance{
		persistent = TRUE
		potency = 2
		icon = 'projectiles.dmi'
		icon_state = "lance"
		sound = "axe"
		description = "(~p). Extends two tiles forward."
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency)
			}
		var{
			stage = 0
			}
		New(){
			. = ..()
			switch(dir){
				if(NORTH){
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y
					}
				if(SOUTH){
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y
					}
				if( EAST){
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y
					}
				if( WEST){
					pixel_x = owner.pixel_x
					pixel_y = owner.pixel_y
					}
				}
			}
		behavior(){
			stage++
			dir = owner.dir
			loc = owner.loc
			owner.icon_state = "attack"
			switch(stage){
				if(1 to 3){
					switch(dir){
						if(NORTH){ pixel_y += 10; c.y += 10}
						if(SOUTH){ pixel_y -= 10; c.y -= 10}
						if( EAST){ pixel_x += 10; c.x += 10}
						if( WEST){ pixel_x -= 10; c.x -= 10}
						}
					}
				if(4 to 6){
					switch(dir){
						if(NORTH){ pixel_y -= 10; c.y -= 10}
						if(SOUTH){ pixel_y += 10; c.y += 10}
						if( EAST){ pixel_x -= 10; c.x -= 10}
						if( WEST){ pixel_x += 10; c.x += 10}
						}
					}
				if(7){
					owner.icon_state = initial(owner.icon_state)
					del src
					}
				}
			}
		redraw(){}
		}
	ball{
		persistent = TRUE
		potency = 2
		icon = 'projectiles.dmi'
		icon_state = "ball"
		width = 11
		height = 11
		movement = MOVEMENT_LAND | MOVEMENT_WATER
		var{
			game/hero/projectile/ball/chain/chain1
			game/hero/projectile/ball/chain/chain2
			game/hero/projectile/ball/chain/chain3
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
			if(!reversed && current_range >= 25 && !(current_range%12)){
				if(owner:aura < 1){
					reverse()
					}
				else{
					owner:adjust_aura(-1)
					}
				}
			. = ..()
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
		impact(var/game/map/mover/combatant/target){
			owner.attack(target, potency)
			reverse()
			}
		horizontal_stop(){
			reverse()
			}
		vertical_stop(){
			reverse()
			}
		var{
			reversed = FALSE
			time = 0
			}
		proc{
			reverse(){
				if(reversed){ return}
				reversed = TRUE
				vel.x *= -1
				vel.y *= -1
				}
			}
		Del(){
			del chain1
			del chain2
			del chain3
			owner.icon_state = null
			. = ..()
			}
		}
	crossbow{
		icon = '_decadence.dmi'
		icon_state = "crossbow"
		description = " (1). Fires a bolt a short distance."
		max_time = 3
		potency = 0
		impact(var/game/map/mover/combatant/target){}
		height = 16
		width  = 16
		persistent = TRUE
		New(){
			. = ..()
			var/game/hero/projectile/arrow/A = new(owner)
			A.max_range = 64
			}
		Del(){
			owner.icon_state = initial(owner.icon_state)
			. = ..()
			}
		behavior(){
			. = ..()
			dir = owner.dir
			owner.icon_state = "attack"
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
	arrow{
		max_time = 32
		icon = 'projectiles.dmi'
		icon_state = "arrow"
		height = 3
		width  = 3
		persistent = FALSE
		var{
			long_width = 16
			short_width = 3
			speed = 6
			unique = TRUE
			}
		New(){
			. = ..()
			spawn(){
				var/game/hero/O = owner
				if(O && O.projectile == src){ O.projectile = null}
				}
			if(unique){
				var/game/hero/projectile/arrow/first_arrow
				for(var/game/hero/projectile/arrow/A in owner.projectiles){
					if(!first_arrow){ first_arrow = A}
					else{
						del first_arrow
						break
						}
					}
				}
			dir = owner.dir
			switch(dir){
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = speed
					height = long_width
					width = short_width
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					height = long_width
					width = short_width
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					height = short_width
					width = long_width
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					height = short_width
					width = long_width
					}
				}
			}
		}
	arrow_flaming{
		parent_type = /game/hero/projectile/arrow
		icon_state = "arrow_flaming"
		short_width = 5
		max_range = 128
		explosive = TRUE
		terminal_explosion = TRUE
		explode(){
			var/game/hero/projectile/fire_stationary/fire = new(owner)
			fire.c.x = (c.x+(width /2)) - fire.width /2
			fire.c.y = (c.y+(height/2)) - fire.height/2
			. = ..()
			}
		}
	arrow_bomb{
		parent_type = /game/hero/projectile/arrow
		icon_state = "arrow_bomb"
		short_width = 5
		max_range = 128
		explosive = TRUE
		terminal_explosion = TRUE
		potency = 3
		impact(){
			explode()
			}
		explode(){
			var/game/hero/projectile/bomb/B = new(owner)
			B.c.x = (c.x+(width /2)) - B.width /2
			B.c.y = (c.y+(height/2)) - B.height/2
			B.redraw()
			B.explode()
			. = ..()
			}
		}
	note{
		parent_type = /game/hero/projectile/magic_1
		icon_state = "note"
		description = "(~p). A musical note travels forward a moderate distance, doing damage to the first enemy it hits."
		potency = 1
		max_range = 96
		speed = 6
		y_offset = -1
		width = 12
		height = 12
		var{
			single = TRUE
			}
		New(){
			. = ..()
			if(!single){ return}
			spawn(){
				var/game/hero/O = owner
				if(O && O.projectile == src){ O.projectile = null}
				}
			var/game/hero/projectile/note/first_note
			for(var/game/hero/projectile/note/N in owner.projectiles){
				if(!first_note){ first_note = N}
				else{
					del first_note
					break
					}
				}
			}
		}
	star{
		parent_type = /game/hero/projectile/magic_1
		icon_state = "star"
		potency = 2
		max_range = 96
		sound = null
		New(){
			. = ..()
			spawn(){
				var/game/hero/O = owner
				if(O && O.projectile == src){ O.projectile = null}
				}
			var/game/hero/projectile/star/first_star
			for(var/game/hero/projectile/star/S in owner.projectiles){
				if(!first_star){ first_star = S}
				else{
					del first_star
					break
					}
				}
			}
		}
	magic_1{
		icon = 'projectiles.dmi'
		icon_state = "fire_ball"
		height = 6
		width  = 6
		persistent = FALSE
		max_range = 96
		sound = "fire_magic"
		var{
			speed = 6
			disable_time = 12
			}
		behavior(){
			. = ..()
			if(disable_time){
				disable_time--
				if(!disable_time){
					var/game/hero/H = owner
					H.projectile = null
					}
				}
			}
		New(){
			. = ..()
			dir = owner.dir
			switch(dir){
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					}
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = speed
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					}
				}
			}
		}
	magic_2{
		parent_type = /game/hero/projectile/magic_1
		max_range = FALSE
		icon_state = "fire_large"
		height = 16
		width  = 16
		potency = 2
		}
	bone{
		parent_type = /game/hero/projectile/magic_1
		icon_state = "bone"
		height = 12
		width = 12
		speed = 3
		}
	fire_persistent{
		parent_type = /game/hero/projectile/magic_1
		icon_state = "fire_ball"
		max_time = 12
		height = 5
		width = 5
		persistent = TRUE
		max_range = FALSE
		potency = 2
		}
	fire_stationary{
		icon = 'enemies.dmi'
		icon_state = "fire_1"
		width = 16
		height = 16
		max_time = 256
		persistent = TRUE
		potency = 2
		}
	healing{
		icon = 'large.dmi'
		icon_state = "healing"
		height = 30
		width = 30
		max_range = 24
		max_time = 8
		sound = "heal_magic"
		impact(var/game/map/mover/combatant/target){}
		}
	light{
		icon = 'large.dmi'
		icon_state = "light"
		potency = 2
		height = 30
		width = 30
		max_range = 24
		persistent = TRUE
		sound = "light_magic"
		impact(var/game/enemy/target){
			if(!istype(target) || !target.undead){
				return
				}
			. = ..()
			}
		}
	light_2{
		icon = 'large.dmi'
		icon_state = "light_2"
		potency = 3
		height = 30
		width = 30
		max_range = 24
		persistent = TRUE
		sound = "light_magic"
		impact(var/game/enemy/target){
			if(!istype(target) || (!target.undead && !target.demon)){
				return
				}
			. = ..()
			}
		}
	barrier{
		icon = 'large.dmi'
		icon_state = "barrier_2"
		persistent = TRUE
		impact(){}
		potency = 1
		height = 24
		width  = 24
		behavior(){
			c.x = (owner.c.x+(owner.width /2))-(width /2)
			c.y = (owner.c.y+(owner.height/2))-(height/2)
			var/defended = FALSE
			for(var/game/map/mover/projectile/P in orange(COLLISION_RANGE,src)){
				if(P.persistent){ continue}
				if(!collision_check(P)){ continue}
				//var/delta_x = abs((P.c.x+(P.width /2)) - (c.x+(width /2)))
				//var/delta_y = abs((P.c.y+(P.height/2)) - (c.y+(height/2)))
				//var/c_range = sqrt((delta_x*delta_x)+(delta_y*delta_y))
				//if(c_range > radius){ continue}
				if(!istype(P.owner, /game/hero)){
					P.Del()
					defended = TRUE
					}
				}
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
				if(icon_state == "barrier_2"){
					icon_state = "barrier_1"
					}
				else if(icon_state == "barrier_1"){
					Del()
					}
				}
			}
		}
	barrier_encircle{
		icon_state = "barrier"
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
	magic_sword{
		parent_type = /game/hero/projectile/arrow
		unique = FALSE
		icon = 'projectiles.dmi'
		icon_state = "sword"
		persistent = FALSE
		sound = "magic"
		potency = 2
		long_width = 16
		short_width = 5
		}
	controlled_sword{
		icon = 'projectiles.dmi'
		icon_state = "sword"
		explosive = TRUE
		potency = 2
		var{
			long_width = 16
			short_width = 5
			speed = 3
			}
		New(){
			. = ..()
			owner.intelligence = src
			dir = owner.dir
			switch(dir){
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = speed
					height = long_width
					width = short_width
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.x = 0
					vel.y = -speed
					height = long_width
					width = short_width
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					vel.y = 0
					height = short_width
					width = long_width
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					vel.y = 0
					height = short_width
					width = long_width
					}
				}
			}
		Del(){
			owner.icon_state = initial(owner.icon_state)
			. = ..()
			}
		explode(){
			var/old_dir = owner.dir
			for(var/_dir in list(NORTH, SOUTH, EAST, WEST)){
				owner.dir = _dir
				var/game/hero/projectile/magic_sword/sword = new(owner)
				sword.max_range = 48
				sword.persistent = TRUE
				var/coord/old_center = new(c.x+width/2, c.y+height/2)
				var/coord/new_center = new(sword.c.x+sword.width/2, sword.c.y+sword.height/2)
				if(old_center.x != new_center.x || old_center.y != new_center.y){
					sword.c.x += round(old_center.x - new_center.x)
					sword.c.y += round(old_center.y - new_center.y)
					}
				}
			owner.dir = old_dir
			. = ..()
			}
		proc{
			intelligence(){
				if(istype(owner) && istype(owner.player)){
					var/game/hero/owner_hero = owner
					owner_hero.icon_state = "cast"
					var/x_translate = 0
					var/y_translate = 0
					if     (EAST  & (owner.player.key_state | owner.player.key_pressed)){ dir = EAST }
					else if(WEST  & (owner.player.key_state | owner.player.key_pressed)){ dir = WEST }
					else if(NORTH & (owner.player.key_state | owner.player.key_pressed)){ dir = NORTH}
					else if(SOUTH & (owner.player.key_state | owner.player.key_pressed)){ dir = SOUTH}
					px_move(x_translate, y_translate)
					owner.player.clear_keys()
					}
				var/coord/old_center = new(c.x+width/2, c.y+height/2)
				switch(dir){
					if(NORTH){
						vel.x = 0
						vel.y = speed
						height = long_width
						width = short_width
						}
					if(SOUTH){
						vel.x = 0
						vel.y = -speed
						height = long_width
						width = short_width
						}
					if(EAST ){
						vel.x = speed
						vel.y = 0
						height = short_width
						width = long_width
						}
					if(WEST ){
						vel.x = -speed
						vel.y = 0
						height = short_width
						width = long_width
						}
					}
				var/coord/new_center = new(c.x+width/2, c.y+height/2)
				if(old_center.x != new_center.x || old_center.y != new_center.y){
					c.x += round(old_center.x - new_center.x)
					c.y += round(old_center.y - new_center.y)
					}
				}
			}
		}
	seeker{
		icon = 'projectiles.dmi'
		icon_state = "magic_2"
		height = 5
		width  = 5
		persistent = FALSE
		potency = 2
		sound = "magic"
		var{
			speed = 3
			}
		New(){
			. = ..()
			vel.x = 0
			vel.y = 0
			switch(owner.dir){
				if(NORTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.y = speed
					}
				if(SOUTH){
					c.x = owner.c.x + round((owner.width -width )/2)
					c.y = owner.c.y
					vel.y = -speed
					}
				if(EAST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = speed
					}
				if(WEST ){
					c.x = owner.c.x
					c.y = owner.c.y + round((owner.height-height)/2)
					vel.x = -speed
					}
				}
			}
		behavior(){
			var/game/enemy/closest
			var/close_dist
			for(var/game/enemy/E in range(COLLISION_RANGE, src)){
				var/dist = (c.x+(width/2)) - (E.c.x+(E.width/2))
				if(!closest){
					closest = E
					close_dist = dist
					continue
					}
				if(dist < close_dist){
					closest = E
					close_dist = dist
					}
				}
			if(!closest){
				.=..()
				return
				}
			vel.x += sign((closest.c.x+(closest.width /2)) - (c.x+(width /2)))
			vel.y += sign((closest.c.y+(closest.height/2)) - (c.y+(height/2)))
			vel.x = min(speed, max(-speed, vel.x))
			vel.y = min(speed, max(-speed, vel.y))
			. = ..()
			}
		}
	wind{
		height = 16
		width = 16
		icon = 'rectangles.dmi'
		icon_state = "smoke"
		sound = "wind"
		potency = 0
		impact(var/game/map/mover/combatant/target){
			var/delta_x = (target.c.x + target.width /2) - (owner.c.x + owner.width /2)
			var/delta_y = (target.c.y + target.height/2) - (owner.c.y + owner.height/2)
			if(abs(delta_x) > abs(delta_y)){
				target.px_move(sign(delta_x)*3, sign(delta_y)  , target.dir)
				}
			else{
				target.px_move(sign(delta_x)  , sign(delta_y)*3, target.dir)
				}
			}
		}
	controlled_orb{
		height = 15
		width = 15
		New(){
			. = ..()
			owner.intelligence = src
			}
		var{
			speed = 2
			}
		impact(){}
		horizontal_stop(){}
		vertical_stop(){}
		proc{
			intelligence(){
				if(istype(owner) && istype(owner.player)){
					var/game/hero/owner_hero = owner
					owner_hero.icon_state = "cast"
					var/x_translate = 0
					var/y_translate = 0
					if(EAST  & (owner.player.key_state | owner.player.key_pressed)){ x_translate += speed}
					if(WEST  & (owner.player.key_state | owner.player.key_pressed)){ x_translate -= speed}
					if(NORTH & (owner.player.key_state | owner.player.key_pressed)){ y_translate += speed}
					if(SOUTH & (owner.player.key_state | owner.player.key_pressed)){ y_translate -= speed}
					px_move(x_translate, y_translate)
					if(PRIMARY & owner.player.key_pressed){         finish()}
					else if(SECONDARY & owner.player.key_pressed){  finish()}
					else if(TERTIARY & owner.player.key_pressed){   finish()}
					else if(QUATERNARY & owner.player.key_pressed){ finish()}
					owner.player.clear_keys()
					}
				}
			finish(){
				/*
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
					*/
				Del()
				}
			}
		}
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
		}
	healing_orb{
		parent_type = /game/hero/projectile/controlled_orb
		icon_state = "healing"
		potency = 2
		finish(){
			var/game/hero/closest
			var/close_distance = 300
			for(var/game/hero/H in orange(COLLISION_RANGE, src)){
				var/h_dist = abs((H.c.x+(H.width/2)) - (c.x+(width/2))) + abs((H.c.y+(H.height/2)) - (c.y+(height/2)))
				if(!closest){
					closest = H
					close_distance = h_dist
					continue
					}
				if(h_dist < close_distance){
					closest = H
					}
				}
			if(closest){
				if(collision_check(closest)){
					var/game/hero/projectile/healing/heal_flash = new(owner)
					heal_flash.c.x = (c.x+(width /2)) - (heal_flash.width /2)
					heal_flash.c.y = (c.y+(height/2)) - (heal_flash.height/2)
					closest.adjust_health(potency)
					}
				}
			if(istype(owner) && istype(owner.player)){
				owner.player.clear_keys()
				}
			owner.icon_state = initial(owner.icon_state)
			Del()
			}
		}
	aura_orb{
		parent_type = /game/hero/projectile/controlled_orb
		icon_state = "aura_orb"
		potency = 2
		finish(){
			var/game/hero/closest
			var/close_distance = 300
			for(var/game/hero/H in orange(COLLISION_RANGE, src)){
				var/h_dist = abs((H.c.x+(H.width/2)) - (c.x+(width/2))) + abs((H.c.y+(H.height/2)) - (c.y+(height/2)))
				if(!closest){
					closest = H
					close_distance = h_dist
					continue
					}
				if(h_dist < close_distance){
					closest = H
					}
				}
			if(closest){
				if(collision_check(closest)){
					var/game/hero/projectile/healing/heal_flash = new(owner)
					heal_flash.icon_state = "light"
					heal_flash.c.x = (c.x+(width /2)) - (heal_flash.width /2)
					heal_flash.c.y = (c.y+(height/2)) - (heal_flash.height/2)
					closest.adjust_aura(potency)
					}
				}
			if(istype(owner) && istype(owner.player)){
				owner.player.clear_keys()
				}
			owner.icon_state = initial(owner.icon_state)
			Del()
			}
		}
	fire_orb{
		parent_type = /game/hero/projectile/controlled_orb
		icon_state = "fire_orb"
		finish(){
			var/game/hero/projectile/fire_stationary/fire = new(owner)
			fire.c.x = c.x
			fire.c.y = c.y
			if(istype(owner) && istype(owner.player)){
				owner.player.clear_keys()
				}
			owner.icon_state = initial(owner.icon_state)
			Del()
			}
		}
	note_orb{
		parent_type = /game/hero/projectile/controlled_orb
		icon_state = "note"
		potency = 1
		width = 12
		height = 12
		speed = 3
		explosive = TRUE
		impact(){
			explode()
			}
		Del(){
			owner.icon_state = initial(owner.icon_state)
			. = ..()
			}
		finish(){
			explode()
			}
		explode(){
			var/old_dir = owner.dir
			var/angle = rand(0,45)
			for(var/_dir in list(0, 45, 90, 135, 180, 225, 270, 315)){
				var/game/hero/projectile/note/note = new /game/hero/projectile/note{single=0}(owner)
				note.vel.x = cos(_dir+angle)*note.speed
				note.vel.y = sin(_dir+angle)*note.speed
				note.max_time = 10
				note.persistent = TRUE
				var/coord/old_center = new(c.x+width/2, c.y+height/2)
				var/coord/new_center = new(note.c.x+note.width/2, note.c.y+note.height/2)
				if(old_center.x != new_center.x || old_center.y != new_center.y){
					note.c.x += round(old_center.x - new_center.x)
					note.c.y += round(old_center.y - new_center.y)
					}
				}
			owner.dir = old_dir
			. = ..()
			}
		}
	fire_snake{
		parent_type = /game/hero/projectile/controlled_orb
		icon = 'enemies.dmi'
		icon_state = "fire_2"
		max_time = 128
		potency = 2
		var{
			list/body = new()
			length = 3
			body_radius = 16
			list/old_positions
			body_state = "fire_2"
			tail_state
			}
		speed = 3
		New(){
			. = ..()
			layer++
			old_positions = new()
			var/game/hero/projectile/lead = src
			for(var/I = 1 to length){
				var/game/hero/projectile/fire_snake/body/B = new(owner)
				B.icon = icon
				B.potency = potency
				B.c.x = c.x+(width -B.width )/2
				B.c.y = c.y+(height-B.height)/2
				body.Add(B)
				if(lead != src){
					var/game/hero/projectile/fire_snake/body/leader = lead
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
				var/old_index = round(I * body_radius/speed)
				if(old_index <= old_positions.len){
					var/game/enemy/archetype/snaking/body/B = body[I]
					if(!B){ continue}
					var/coord/new_c = old_positions[old_index]
					B.dir = old_positions[new_c]
					B.c.x = new_c.x
					B.c.y = new_c.y
					}
				}
			old_positions.len = min(old_positions.len, round(body.len*body_radius/speed))
			}
		finish(){}
		Del(){
			for(var/game/hero/projectile/P in body){
				del P
				}
			owner.icon_state = initial(owner.icon_state)
			. = ..()
			}
		body{
			parent_type = /game/hero/projectile
			persistent = TRUE
			var{
				game/hero/projectile/fire_snake/head
				game/hero/projectile/lead
				game/hero/projectile/follower
				}
			}
		}
	fist{
		icon_state = "fist"
		height = 8
		width  = 8
		persistent = TRUE
		potency = 2
		max_time = 5
		var{
			speed = 4
			}
		New(){
			. = ..()
			layer = owner.layer+1
			dir = owner.dir
			owner.icon_state = "attack"
			vel.x = 0
			vel.y = 0
			c.x = owner.c.x + round((owner.width -width )/2)
			c.y = owner.c.y + round((owner.height-height)/2)
			switch(dir){
				if(NORTH){
					vel.y = speed
					}
				if(SOUTH){
					vel.y = -speed
					}
				if(EAST ){
					vel.x = speed
					}
				if(WEST ){
					vel.x = -speed
					}
				}
			}
		Del(){
			owner.icon_state = initial(owner.icon_state)
			. = ..()
			}
		}
	pushing_fist{
		parent_type = /game/hero/projectile/fist
		max_time = 4
		speed = 8
		persistent = FALSE
		impact(var/game/map/mover/combatant/target){
			var/game/hero/projectile/pushing_fist/pusher/P = new(owner)
			P.push_dir = dir
			target.intelligence = P
			owner.attack(target, potency)
			}
		pusher{
			parent_type = /game/map/mover/intelligence
			var{
				push_dir
				push_speed = 4
				push_time = 48
				}
			intelligence(var/game/map/mover/M){
				M.behavior()
				switch(push_dir){
					if(NORTH){ M.translate(0,  push_speed)}
					if(SOUTH){ M.translate(0, -push_speed)}
					if(WEST ){ M.translate(-push_speed, 0)}
					if(EAST ){ M.translate( push_speed, 0)}
					}
				if(--push_time <= 0){ Del()}
				}
			}
		}
	fire_dance{
		var{
			angle = 0
			speed = 3
			}
		potency = 2
		max_time = 120
		persistent = TRUE
		icon_state = "fire_dance"
		horizontal_stop(){
			angle += 180
			}
		vertical_stop(){
			angle += 180
			}
		behavior(){
			angle += rand(-32, 32)
			vel.x = round(cos(angle) * speed)
			vel.y = round(sin(angle) * speed)
			. = ..()
			}
		}
	freeze_dance{
		var{
			angle = 0
			speed = 3
			}
		potency = 0
		max_time = 120
		persistent = TRUE
		icon_state = "freeze_dance"
		impact(var/game/map/mover/combatant/target){
			target.intelligence = new /game/map/mover/intelligence/freezer(170)
			}
		horizontal_stop(){
			angle += 180
			}
		vertical_stop(){
			angle += 180
			}
		behavior(){
			angle += rand(-32, 32)
			vel.x = round(cos(angle) * speed)
			vel.y = round(sin(angle) * speed)
			. = ..()
			}
		}
	bomb{
		icon = 'items.dmi'
		icon_state = "bomb_live"
		layer = MOB_LAYER+1
		width = 6
		height = 6
		persistent = TRUE
		max_time = 48
		potency = 0
		terminal_explosion = TRUE
		var{
			blast_range = 32
			}
		collision_check(){}
		explode(){
			max_time = 32
			current_time = 0
			terminal_explosion = FALSE
			icon = null
			for(var/I = 1 to 7){
				var/image/II = image('rectangles.dmi', src, "smoke")
				switch(I){
					if(1){
						II.pixel_x = 3-8
						II.pixel_y = 3-8
						}
					if(2){
						II.pixel_x = -5 + 16
						II.pixel_y = -5
						}
					if(3){
						II.pixel_x = -5 + 8
						II.pixel_y = -5 + 16
						}
					if(4){
						II.pixel_x = -5 - 8
						II.pixel_y = -5 + 16
						}
					if(5){
						II.pixel_x = -5 - 16
						II.pixel_y = -5
						}
					if(6){
						II.pixel_x = -5 - 8
						II.pixel_y = -5 - 16
						}
					if(7){
						II.pixel_x = -5 + 8
						II.pixel_y = -5 - 16
						}
					}
				underlays.Add(II)
				}
			for(var/game/map/mover/combatant/C in range(COLLISION_RANGE, src)){
				if(istype(C, /game/hero) && (C != owner)){ continue}
				var/dist = max(
					abs((C.c.x+(C.width /2)) - (c.x+(width /2))),
					abs((C.c.y+(C.height/2)) - (c.y+(height/2))),
					)
				if(dist <= blast_range){
					C.hurt(3, src)
					}
				}
			}
		}
	}