game/hero/custom/seferiel{
	parent_type = /game/hero/gypsy
	icon = 'seferiel.dmi'
	level_knight = 0
	level_priest = 0
	level_mage   = 0
	level_rogue  = 0
	skill1_cost = 3
	skill1 = /game/hero/custom/seferiel/protect
	protect{
		parent_type = /game/hero/skill/protect
		name = "Protect"
		activate(){
			if(rand() < 0.1){
				var/game/hero/projectile/note_orb/_note_orb = new(owner)
				_note_orb.max_time = 5
				}
			. = ..()
			}
		}
	}