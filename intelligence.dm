game/map/mover/intelligence{
	parent_type = /datum
	proc{
		intelligence(){}
		}
	freezer{
		var{
			time = 0
			}
		New(var/_time = 0){
			time = _time
			}
		intelligence(var/game/map/mover/mover){
			if(time-- <= 0){
				if(istype(mover, /game/hero)){
					mover.icon_state = initial(mover.icon_state)
					}
				Del()
				}
			}
		}
	cast{
		var{
			time = 0
			}
		New(var/_time = 0){
			time = _time
			}
		intelligence(var/game/map/mover/mover){
			mover.icon_state = "cast"
			if(time-- <= 0){
				mover.icon_state = initial(mover.icon_state)
				Del()
				}
			}
		}
	slow{
		var{
			time = 0
			}
		New(var/_time = 0){
			time = _time
			}
		intelligence(var/game/map/mover/mover){
			if(time-- <= 0){
				Del()
				}
			switch(time){
				if(64 to 128){}
				if(64 to  96){}// if(!(time % 4)){ mover.behavior()}}
				if(32 to  63){ if(!(time % 4)){ mover.behavior()}}
				if( 0 to  31){ if(!(time % 3)){ mover.behavior()}}
				}
			}
		}
	afk_check{
		var{
			waves = 0
			}
		intelligence(var/game/map/mover/mover){
			var/game/hero/H = mover
			if(!istype(H)){ finish()}
			if(H.player){
				if(EAST  & (H.player.key_state | H.player.key_pressed)){ finish()}
				if(WEST  & (H.player.key_state | H.player.key_pressed)){ finish()}
				if(NORTH & (H.player.key_state | H.player.key_pressed)){ finish()}
				if(SOUTH & (H.player.key_state | H.player.key_pressed)){ finish()}
				if(PRIMARY    & H.player.key_pressed){ finish()}
				if(SECONDARY  & H.player.key_pressed){ finish()}
				if(TERTIARY   & H.player.key_pressed){ finish()}
				if(QUATERNARY & H.player.key_pressed){ finish()}
				}
			}
		proc{
			finish(){
				Del()
				}
			increase_afk(var/game/hero/who, var/amount = 1){
				waves += amount
				if(waves >= AFK_WAVES){
					if(who.player){
						who.player.spectate()
						Del()
						}
					}
				}
			}
		}
	}