game{

	var{
		game/audio_library/audio = new()
		}
	audio_library{
		parent_type = /datum
		var{
			list/sound = list(/*
				"sword"        = 'sword_1.wav',
				"axe"          = 'axe_2.wav',
				"defend"       = 'defended_1.wav',
				"small_hurt"   = 'hurt_4.wav',
				"small_die"    = 'hurt_3.wav',
				"player_hurt"  = 'player_hurt_2.wav',
				"wind"         = 'wind_1.wav',
				"magic"        = 'magic_bounce_1.wav',
				"heal_magic"   = 'heal_2.wav',
				"light_magic"  = 'heal_1.wav',
				"defend_magic" = 'heal_3.wav',
				"fire_magic"   = 'fire_1.wav',
				"gooey"        = 'gooey_1.wav',
				*/)
			list/music = list(

				)
			}
		proc{
			play_sound(which, who){
				if(!who){
					who = game.heros + game.waiting + game.spectators
					}
				if(which in sound){
					world << sound(sound[which], FALSE, FALSE, 0, 10)
					}
				}
			}
		}
	}