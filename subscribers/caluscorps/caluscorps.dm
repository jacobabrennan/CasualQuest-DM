game/hero/subscriber/caluscorps{
	//name="Claus"
	icon = 'caluscorps.dmi'
	level_knight = 0
	level_rogue = 0
	max_health = 7
	max_aura = 5
	speed = 2
	projectile_type = /game/hero/subscriber/caluscorps/candy_cane
	skill1_cost = 1
	skill2_cost = 3
	skill3_cost = 3
	skill1 = /game/hero/skill/ccheal
	skill2 = /game/hero/skill/explode_gift
	skill3 = /game/hero/skill/summon_elf
	candy_cane{
		parent_type = /game/hero/projectile/sword
		icon = 'caluscorps.dmi'
		state_name = "cane"
		potency = 1
		}
	New(){
		. = ..()
		var/obj/temp_o = new()
		var/image/help = image(icon, null, "help", MOB_LAYER+1)
		help.pixel_y += TILE_HEIGHT
		temp_o.overlays.Add(help)
		for(var/appearance in temp_o.overlays){
			arr_overlay = appearance
			}
		del temp_o
		}

	elf{
		parent_type = /game/hero/summon/archetype/normal
		max_health = 7
		max_aura = 2
		aura_rate = 20
		icon = 'caluscorps.dmi'
		icon_state = "elf"
		move_toggle = -1
		projectile_type = null
		skill1 = /game/hero/skill/ccgift
		var{
			max_time = 256
			}
		New(){
			. = ..()
			invulnerable = max_time
			adjust_aura(-(max_aura-1))
			}
		behavior(){
			. = ..()
			max_time--
			if(max_time <= 0){
				aura = max_aura
				var/game/hero/skill/new_skill = new skill1(src)
				new_skill.activate()
				die()
				return
				}
			if(aura){
				var/game/hero/skill/new_skill = new skill1(src)
				new_skill.activate()
				}
			}
		}
	gift{
		parent_type = /game/item
		icon = 'caluscorps.dmi'
		icon_state = "gift_1"
		lifespan = 512
		var{
			gift_type = 1
			}
		New(){
			. = ..()
			gift_type = pick(1,2,3)
			icon_state = "gift_[pick(1,2,3)]"
			}
		activate(var/game/hero/hero){
			if(istype(hero, /game/hero/subscriber/caluscorps/elf)){ return}
			switch(gift_type){
				if(1){
					hero.adjust_health(1)
					}
				if(2){
					hero.adjust_aura(1)
					}
				if(3){
					hero.invulnerable += 96
					}
				}
			. = ..()
			}
		}
	exploding_gift{
		parent_type = /game/hero/projectile/arrow_flaming
		icon = 'caluscorps.dmi'
		icon_state = "gift_1"
		long_width = 8
		short_width = 8
		New(){
			. = ..()
			icon_state = "gift_[pick(1,2,3)]"
			}
		}
	}