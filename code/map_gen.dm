
game{
	var{
		obj/eye
		}
	New(){
		eye = new(null)
		. = ..()
		}
	}

game/map{
	icon_state = "floor"
	tile{
		parent_type = /turf
		icon = 'debug_tiles.dmi'
		var{
			movement = MOVEMENT_LAND
			}
		proc{
			reset(){}
			}
		outer_wall{
			icon_state = "wall"
			movement = MOVEMENT_WALL
			}
		pillar{
			icon_state = "pillar"
			movement = MOVEMENT_WALL
			}
		floor{
			icon_state = "floor"
			}
		bridge_hor{
			icon_state = "bridge_hor"
			}
		bridge_ver{
			icon_state = "bridge_ver"
			}
		water{
			movement = MOVEMENT_WATER
			icon_state = "water_0"
			}
		passage{
			icon_state = "passage"
			}
		boss{
			icon_state = "floor"
#ifdef DEBUG
			icon_state = "boss"
#endif
			}
		}/*
	monster_generator{
		parent_type = /obj
		icon = 'debug_tiles.dmi'
		var{
			level = 1
			}/*
		_1{ level = 1}
		_2{ level = 2}
		_3{ level = 3}
#ifdef DEBUG
		_1{ icon_state = "1"}
		_2{ icon_state = "2"}
		_3{ icon_state = "3"}
#endif*/
		}*/
	}