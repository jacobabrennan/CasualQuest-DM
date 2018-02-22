

//------------------------------------------------------------------------------

#ifndef TILE_WIDTH
#define TILE_WIDTH 32
#endif
#ifndef TILE_HEIGHT
#define TILE_HEIGHT 32
#endif

world
	icon_size = TILE_WIDTH


//-- Mover ---------------------------------------------------------------------

game/map/mover
	parent_type = /obj
	animate_movement = FALSE
	var
		coord/c = new(0, 0)
		width = TILE_WIDTH
		height = TILE_HEIGHT
		x_offset = 0
		y_offset = 0
		movement = MOVEMENT_LAND

	proc

		redraw()
			var/new_x = 1 + round((c.x+round(width/2))/TILE_WIDTH)
			pixel_x = (c.x+round(width/2))%TILE_HEIGHT + (x_offset-round(width/2))
			var/new_y = 1 + round((c.y+round(height/2))/TILE_HEIGHT)
			pixel_y = (c.y+round(height/2))%TILE_HEIGHT + (y_offset-round(height/2))
			var/turf/T
			if(!z)
				T = locate(new_x, new_y, game.map.z)
			else
				T = locate(new_x, new_y, game.map.z)
			if(T != loc)
				if(!istype(T)) return
				var/atom/old_loc = loc
				var/area/old_area = aloc(src)
				loc = T
				var/area/new_area = aloc(src)
				if(old_area)
					if(old_area != new_area)
						old_area.Exited(src)
						new_area.Entered(src, old_loc)
					old_loc.Exited(src)
				T.Entered(src, old_loc)

		horizontal_stop(){}

		vertical_stop(){}
		translate(x_amount, y_amount)
			x_amount = max(-(TILE_WIDTH -1), min((TILE_WIDTH -1), x_amount))
			y_amount = max(-(TILE_HEIGHT-1), min((TILE_HEIGHT-1), y_amount))
			if(!x_amount && !y_amount) return
			// Determine if movement will cause the object's edge to cross a border between turfs.
			var/x_pole
			var/y_pole
			if(!x_amount)
				x_pole = 1
			else
				x_pole = x_amount > 0 ? 1 : -1
			if(!y_amount)
				y_pole = 1
			else
				y_pole = y_amount > 0 ? 1 : -1
			var/check_x = FALSE
			var/check_y = FALSE
			if(x_pole == 1)
				var/limit = TILE_WIDTH - (c.x-1 + width)%TILE_WIDTH
				if(x_amount >= limit)
					c.x += limit-1
					x_amount -= limit-1
					check_x = TRUE
			else if(x_pole == -1)
				var/limit = (c.x+1)%TILE_WIDTH
				if(abs(x_amount) >= limit)
					c.x += limit-1
					x_amount -= limit-1
					check_x = TRUE
			if(y_pole == 1)
				var/limit = TILE_HEIGHT - (c.y-1 + height)%TILE_HEIGHT
				if(y_amount >= limit)
					c.y += limit-1
					y_amount -= limit-1
					check_y = TRUE
			else if(y_pole == -1)
				var/limit = (c.y+1)%TILE_HEIGHT
				if(abs(y_amount) >= limit)
					c.y += limit-1
					y_amount -= limit-1
					check_y = TRUE
			// Determine size of border crossed, in tiles
				// If the object is centered in a turf and is less than or equal to icon_size, this number will be 1
				// If the object is 3x world.icon_size, then this number could be as much as 4.
			var/base_width  = max(1, round(width /TILE_WIDTH )) + (((c.x%TILE_WIDTH )+width -1)>=TILE_WIDTH ? 1 : 0)
			var/side_height = max(1, round(height/TILE_HEIGHT)) + (((c.y%TILE_HEIGHT)+height-1)>=TILE_HEIGHT? 1 : 0)
			if(check_x)
				if(x_pole == 1)
					var/target_x = round((c.x+width+x_amount)/TILE_WIDTH)+1
					for(var/I = 1 to side_height)
						var/target_y = round(c.y/TILE_HEIGHT)+I
						var/game/map/tile/target = locate(target_x, target_y, game.map.z)
						var/atom/dense_object
						if(target)
							dense_object = target.dense(src)
						if(!target || dense_object)
							x_amount = 0
							horizontal_stop()
							Bump(dense_object)
							c.x = ((target_x-1)*TILE_WIDTH)-width
							break
				else if(x_pole == -1)
					var/target_x = round((c.x+x_amount)/TILE_WIDTH)+1
					for(var/I = 1 to side_height)
						var/target_y = round(c.y/TILE_HEIGHT)+I
						var/game/map/tile/target = locate(target_x, target_y, game.map.z)
						var/atom/dense_object
						if(target)
							dense_object = target.dense(src)
						if(!target || dense_object)
							x_amount = 0
							horizontal_stop()
							Bump(dense_object)
							c.x = ((target_x)*TILE_WIDTH)
							break
			c.x += x_amount
			base_width  = max(1, round(width /TILE_WIDTH )) + (((c.x%TILE_WIDTH )+width -1)>=TILE_WIDTH ? 1 : 0)
			side_height = max(1, round(height/TILE_HEIGHT)) + (((c.y%TILE_HEIGHT)+height-1)>=TILE_HEIGHT? 1 : 0)
			if(check_y)
				if(y_pole == 1)
					var/target_y = round((c.y+height+y_amount)/TILE_HEIGHT)+1
					for(var/I = 1 to base_width)
						var/target_x = round(c.x/TILE_WIDTH)+I
						var/game/map/tile/target = locate(target_x, target_y, game.map.z)
						var/atom/dense_object
						if(target)
							dense_object = target.dense(src)
						if(!target || dense_object)
							y_amount = 0
							vertical_stop()
							Bump(dense_object)
							c.y = ((target_y-1)*TILE_HEIGHT)-height
							break
				else if(y_pole == -1)
					var/target_y = round((c.y+y_amount)/TILE_HEIGHT)+1
					for(var/I = 1 to base_width)
						var/target_x = round(c.x/TILE_WIDTH)+I
						var/game/map/tile/target = locate(target_x, target_y, game.map.z)
						var/atom/dense_object
						if(target)
							dense_object = target.dense(src)
						if(!target || dense_object)
							y_amount = 0
							vertical_stop()
							Bump(dense_object)
							c.y = ((target_y)*TILE_HEIGHT)
							break
			c.y += y_amount
			redraw(x_amount, y_amount)

		px_move(x_amount, y_amount, new_direction)
			if(!x_amount && !y_amount && !new_direction) return
			// Determine new dir
			if(new_direction)
				dir = new_direction
			else
				var/theta = arctan(x_amount, y_amount)
				switch(theta)
					if(  0 to  45, 315 to 360) dir = EAST
					if( 45 to 135            ) dir = NORTH
					if(135 to 225            ) dir = WEST
					if(225 to 315            ) dir = SOUTH
			// Move
			translate(x_amount, y_amount)

		collision_check(var/game/map/mover/_mover)
			if(    abs((c.x+(width /2)) - (_mover.c.x+(_mover.width /2))) < (width +_mover.width )/2)
				if(abs((c.y+(height/2)) - (_mover.c.y+(_mover.height/2))) < (height+_mover.height)/2)
					return TRUE

		dir_to(var/game/map/mover/_mover)
			var/coord/c1 = new(       c.x+(       width/2),        c.y+(       height/2))
			var/coord/c2 = new(_mover.c.x+(_mover.width/2), _mover.c.y+(_mover.height/2))
			if(abs(c1.x - c2.x) >= abs(c1.y - c2.y))
				if(c1.x > c2.x) return WEST
				else            return EAST
			else
				if(c1.y > c2.y) return SOUTH
				else            return NORTH

//-- Grid Biased Movement ------------------------
game/map/mover/gridded
	translate(x_amo, y_amo)
		if(     x_amo && !y_amo)
			var/asdf = c.y % (TILE_HEIGHT/2)
			if(asdf)
				if((asdf - (TILE_HEIGHT/4)) >= 0)
					y_amo++
				else
					y_amo--
		else if(y_amo && !x_amo)
			var/asdf = c.x % (TILE_WIDTH/2)
			if(asdf)
				if((asdf - (TILE_WIDTH/4)) >= 0)
					x_amo++
				else
					x_amo--
		. = ..()

//-- Control -------------------------------------
game/map/mover
	var
		datum/intelligence
		client/player
	proc
		take_turn()
			if(intelligence)
				if(hascall(intelligence, "intelligence"))
					call(intelligence, "intelligence")(src)
					return
			if(istype(player))
				player.intelligence(src)
				return
			else
				behavior()
		behavior(){}

//-- Tile Density --------------------------------
game/map/tile
	proc
		dense(var/game/map/mover/skip_object)
			if(!(movement & skip_object.movement)) return src
			if(loc.density) return loc
