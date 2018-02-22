

//-- Item Type Defs ------------------------------------------------------------

game/item
	cherry{
		icon_state = "cherry"
		var{
			potency = 1
			}
		activate(var/game/hero/hero){
			var/result = hero.adjust_health(potency)
			if(result){
				.=..()
				}
			}
		}
	plum{
		icon_state = "plum"
		var{
			potency = 5
			}
		activate(var/game/hero/hero){
			var/result = hero.adjust_health(potency)
			if(result){
				.=..()
				}
			}
		}
	bottle{
		icon_state = "bottle"
		var{
			potency = 5
			}
		activate(var/game/hero/hero){
			var/result = hero.adjust_aura(hero.max_aura)
			if(result){
				.=..()
				}
			}
		}
	shield{
		icon_state = "shield"
		var{
			potency = 150
			}
		activate(var/game/hero/hero){
			hero.invulnerable = max(potency, hero.invulnerable)
			. = ..()
			}
		}
	coin_gold{
		parent_type = /game/item/coin_silver
		icon_state = "coin_gold"
		value = 100
		}
	coin_silver{
		icon_state = "coin_silver"
		var{
			value = 25
			}
		activate(var/game/hero/hero){
			for(var/game/hero/H in game.heros){
				if(H.player){
					var/game/item/coin_silver/score_marker/S = new(H)
					S.setup(H, value)
					H.player.award_score(value)
					}
				}
			. = ..()
			}
		score_marker{
			parent_type = /game/map/mover/projectile
			icon = 'rectangles.dmi'
			potency = 0
			layer = FLY_LAYER
			width = 16
			height = 16
			var{
				activated = TRUE
				lifespan = 32
				}
			impact(){}
			behavior(){
				. = ..()
				y_offset++
				lifespan--
				if(lifespan <= 0){
					Del()
					}
				}
			proc{
				setup(var/game/hero/H, value){
					icon_state = "score_[value]"
					c.x = H.c.x
					c.y = H.c.y
					redraw()
					}
				}
			}
		}
	chest{
		icon = 'rectangles.dmi'
		icon_state = "chest"
		lifespan = 10000000000000000000000
		behavior(){}
		activate(){}
		}
	weapon{
		icon = 'projectiles.dmi'
		dir = NORTH
		width = 16
		height = 16
		var{
			weapon_type = /game/hero/projectile/wood_sword
			}
		activate(var/game/hero/hero){
			hero.projectile_type = weapon_type
			. = ..()
			}
		gold_axe{
			icon_state = "gold_axe"
			weapon_type = /game/hero/projectile/gold_axe
			}
		}