

//-- Key State -----------------------------------------------------------------

client
	var
		key_state = 0
		key_pressed = 0
		old_keys  = 0
		keys_stick = 0

	proc
		reset()
			key_state = 0
			old_keys = 0
			key_pressed = 0

	verb

		key_up(which as num)
			set name = "key_up"
			set hidden = TRUE
			key_state &= ~which
			old_keys &= ~which
			if(which < 16)
				var/opposite = turn(which, 180)
				if(opposite & old_keys)
					key_state |= opposite
					keys_stick |= opposite
					old_keys &= ~opposite

		key_down(which as num)
			set name = "key_down"
			set hidden = TRUE
			if(which == PRIMARY && eye != game.eye && !(src in game.waiting + game.spectators))
				join()
			if((which in list(SHIFT_PRIMARY)) && (eye != game.eye))
				join_hard()
			if(which < 16)
				var/opposite = turn(which, 180)
				if(opposite & key_state)
					key_state &= ~opposite
					keys_stick &= ~opposite
					old_keys |= opposite
			keys_stick |= which
			key_state |= which
			key_pressed |= which

	proc

		key_state(which)
			return (key_state | keys_stick) & which

		key_check()
			var/u    = key_state & NORTH
			var/d  = key_state & SOUTH
			var/l  = key_state &  WEST
			var/r = key_state &  EAST
			world << "[u? "\green":"\red"]^[d?"\green":"\red"]v[l?"\green":"\red"]&lt;[r?"\green":"\red"]&gt;"

		clear_key(which)
			key_state &= ~which

		clear_keys(save_buttons)
			key_pressed = 0
			//keys_stick = 0
			//key_state = 0
