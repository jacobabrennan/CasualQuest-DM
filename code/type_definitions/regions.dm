
//-- Region Type Defs ----------------------------------------------------------

game/map/region
	forest{
		icon = 'forrest.dmi'
		weak_enemies = list( // 1-3, 4-24, 25-45, 46-66, 67-87, 88-108, 109-129, 130-150
			/game/enemy/bug/_1,
			/game/enemy/bug/_2,
			/game/enemy/bug/_3,
			/game/enemy/boar/_2,
			/game/enemy/boar/_3,
			)
		medium_enemies = list( // 1-31, 32-52, 53-73, 74-94, 95-115, 116-136, 137-157
			/game/enemy/bird/_1,
			/game/enemy/bird/_2,
			/game/enemy/bird/_2,
			/game/enemy/bird/_3,
			/game/enemy/bird/_3,
			)
		strong_enemies = list( // 1-16, 17-27, 28-48, 49-69, 70-90, 91-101, 102-122, 123-143
			/game/enemy/boar/_1,
			/game/enemy/boar/_2,
			/game/enemy/boar/_3,
			/game/enemy/tarantula/_1,
			/game/enemy/tarantula/_2,
			/game/enemy/tarantula/_3,
			list(/game/enemy/bowser/_3,/game/enemy/tarantula/_3),
			)
		bosses = list( // 9-29, 39-49, 59-69, 79-89
			/game/enemy/tarantula/_1,
			/game/enemy/bowser/_1,
			/game/enemy/bowser/_2,
			/game/enemy/bowser/_3,
			)
		}
	desert{
		icon = 'desert.dmi'
		weak_enemies = list(
			/game/enemy/bug/_1,
			/game/enemy/snake/_1,
			/game/enemy/snake/_2,
			/game/enemy/snake/_3,
			/game/enemy/mummy/_1,
			/game/enemy/mummy/_2,
			/game/enemy/mummy/_3,
			)
		medium_enemies = list(
			/game/enemy/digger/_1,
			/game/enemy/digger/_2,
			/game/enemy/digger/_3,
			/game/enemy/wizard/_2,
			/game/enemy/wizard/_3,
			list(/game/enemy/wizard/_3, /game/enemy/turtle/_3),
			)
		strong_enemies = list(
			/game/enemy/spine/_1,
			/game/enemy/spine/_2,
			/game/enemy/spine/_3,
			/game/enemy/turtle/_3,
			/game/enemy/tarantula/_2,
			/game/enemy/tarantula/_3,
			)
		bosses = list(
			/game/enemy/scorpion/_1,
			/game/enemy/scorpion/_2,
			/game/enemy/scorpion/_2,
			/game/enemy/scorpion/_3,
			)
		}
	swamp{
		icon = 'swamp.dmi'
		weak_enemies = list(
			/game/enemy/bug/_1,
			/game/enemy/scuzzy/_1,
			/game/enemy/scuzzy/_2,
			/game/enemy/scuzzy/_3,
			/game/enemy/mummy/_1,
			/game/enemy/mummy/_2,
			/game/enemy/mummy/_3,
			)
		medium_enemies = list(
			/game/enemy/bird/_1,
			/game/enemy/bird/_2,
			/game/enemy/bird/_3,
			/game/enemy/wizard/_2,
			/game/enemy/wizard/_3,
			)
		strong_enemies = list(
			/game/enemy/turtle/_1,
			/game/enemy/turtle/_2,
			/game/enemy/tarantula/_1,
			/game/enemy/eye_mass/_1,
			list(/game/enemy/tarantula/_2, /game/enemy/blob/_1),
			list(/game/enemy/tarantula/_3, /game/enemy/blob/_2),
			)
		bosses = list( // 9-29, 39-49, 59-69, 79-89
			/game/enemy/eye_mass/_1,
			/game/enemy/eye_mass/_2,
			/game/enemy/eye_mass/_2,
			/game/enemy/eye_mass/_3,
			/game/enemy/eye_mass/_3,
			)
		}
	graveyard{
		icon = 'graveyard.dmi'
		weak_enemies = list( // 1-3, 4-24, 25-45, 46-66, 67-87, 88-108, 109-129, 130-150
			/game/enemy/bug/_1,
			/game/enemy/skull/_1,
			/game/enemy/skull/_2,
			/game/enemy/skull/_3,
			/game/enemy/mummy/_1,
			/game/enemy/mummy/_2,
			/game/enemy/mummy/_3,
			)
		medium_enemies = list( // 1-31, 32-52, 53-73, 74-94, 95-115, 116-136, 137-157
			/game/enemy/ghost/_1,
			/game/enemy/ghost/_2,
			/game/enemy/ghost/_3,
			/game/enemy/spine/_1,
			/game/enemy/spine/_2,
			/game/enemy/spine/_3,
			)
		strong_enemies = list( // 1-16, 17-27, 28-48, 49-69, 70-90, 91-101, 102-122, 123-143
			/game/enemy/mummy/_1,
			/game/enemy/mummy/_2,
			/game/enemy/mummy/_3,
			/game/enemy/spine/_3,
			/game/enemy/bouncing_skull/_1,
			/game/enemy/bouncing_skull/_2,
			list(/game/enemy/bouncing_skull/_3, /game/enemy/reaper/_1),
			list(/game/enemy/bouncing_skull/_3, /game/enemy/reaper/_2),
			)
		bosses = list(
			/game/enemy/reaper/_1,
			/game/enemy/reaper/_2,
			/game/enemy/reaper/_3,
			)
		}
	cave{
		icon = 'cave.dmi'
		weak_enemies = list(
			/game/enemy/bat/_1,
			/game/enemy/bat/_1,
			/game/enemy/bat/_2,
			/game/enemy/bat/_3,
			)
		medium_enemies = list(
			/game/enemy/scuzzy/_1,
			/game/enemy/scuzzy/_2,
			/game/enemy/scuzzy/_2,
			/game/enemy/genie/_1,
			/game/enemy/genie/_2,
			/game/enemy/genie/_3,
			)
		strong_enemies = list(
			/game/enemy/genie/_1,
			/game/enemy/genie/_2,
			/game/enemy/genie/_3,
			/game/enemy/dragon/_1,
			/game/enemy/dragon/_2,
			/game/enemy/dragon/_3,
			)
		bosses = list( // 9-29, 39-49, 59-69, 79-89
			/game/enemy/dragon/_1,
			list(/game/enemy/blob/_1, /game/enemy/dragon/_2),
			list(/game/enemy/blob/_2, /game/enemy/dragon/_3),
			/game/enemy/blob/_2,
			/game/enemy/blob/_3,
			)
		}
	castle{
		icon = 'castle.dmi'
		weak_enemies = list( // 1-3, 4-24, 25-45, 46-66, 67-87, 88-108, 109-129, 130-150
			/game/enemy/bug/_1,
			/game/enemy/bat/_1,
			/game/enemy/bat/_2,
			/game/enemy/bat/_3,
			/game/enemy/knight/_1,
			/game/enemy/knight/_2,
			/game/enemy/knight/_3,
			/game/enemy/boss_knight/_1,
			)
		medium_enemies = list( // 1-31, 32-52, 53-73, 74-94, 95-115, 116-136, 137-157
			/game/enemy/knight/_1,
			/game/enemy/knight/_2,
			/game/enemy/knight/_3,
			/game/enemy/boss_knight/_1,
			/game/enemy/boss_knight/_2,
			)
		strong_enemies = list( // 1-16, 17-27, 28-48, 49-69, 70-90, 91-101, 102-122, 123-143
			/game/enemy/wizard/_1,
			/game/enemy/wizard/_2,
			/game/enemy/wizard/_3,
			/game/enemy/dragon/_1,
			/game/enemy/dragon/_2,
			/game/enemy/dragon/_3,
			)
		bosses = list( // 9-29, 39-49, 59-69, 79-89
			/game/enemy/boss_knight/_1,
			/game/enemy/boss_knight/_2,
			/game/enemy/boss_knight/_3,
			)
		}/*
	sky{
		icon = 'sky.dmi'
		weak_enemies = list(
			/game/enemy/bug/_1,
			/game/enemy/bat/_1,
			/game/enemy/bat/_2,
			/game/enemy/bat/_3,
			/game/enemy/knight/_1,
			)
		medium_enemies = list(
			/game/enemy/knight/_1,
			/game/enemy/knight/_2,
			/game/enemy/knight/_3,
			/game/enemy/boss_knight/_1,
			)
		strong_enemies = list(
			/game/enemy/wizard/_1,
			/game/enemy/wizard/_2,
			//game/enemy/wizard/_3,
			/game/enemy/dragon/_1,
			/game/enemy/dragon/_2,
			/game/enemy/dragon/_3,
			)
		bosses = list(
			/game/enemy/boss_knight/_1,
			/game/enemy/boss_knight/_2,
			/game/enemy/boss_knight/_3,
			)
		}*/
	hell{
		icon = 'hell.dmi'
		weak_enemies = list( // 1-3, 4-24, 25-45, 46-66, 67-87, 88-108, 109-129, 130-150
			/game/enemy/bug/_1,
			/game/enemy/imp/_1,
			/game/enemy/imp/_2,
			/game/enemy/imp/_3,
			/game/enemy/imp/_3,
			/game/enemy/imp/_3,
			/game/enemy/imp/_3,
			list(/game/enemy/imp/_3, /game/enemy/imp/_3, /game/enemy/vampire/_1),
			)
		medium_enemies = list( // 1-31, 32-52, 53-73, 74-94, 95-115, 116-136, 137-157
			/game/enemy/fire_wall/_1,
			/game/enemy/fire_wall/_2,
			/game/enemy/fire_wall/_2,
			/game/enemy/fire_wall/_3,
			/game/enemy/fire_wall/_3,
			/game/enemy/fire_wall/_3,
			list(/game/enemy/demon/_1, /game/enemy/fire_wall/_3),
			)
		strong_enemies = list( // 1-16, 17-27, 28-48, 49-69, 70-90, 91-101, 102-122, 123-143
			/game/enemy/vampire/_1,
			/game/enemy/vampire/_2,
			/game/enemy/vampire/_3,
			/game/enemy/vampire/_3,
			/game/enemy/vampire/_3,
			/game/enemy/demon/_1,
			/game/enemy/demon/_1,
			/game/enemy/demon/_2,
			)
		bosses = list( // 9-29, 39-49, 59-69, 79-89
			/game/enemy/demon/_1,
			/game/enemy/demon/_2,
			/game/enemy/demon/_3,
			)
		}
	gnome{
		icon = 'gnome.dmi'
		enemies(wave, boss){
			var/list/E
			switch(wave){
				if(199 to 202){
					E = list(/game/enemy/salty/_2, /game/enemy/mrbubble, /game/enemy/salty/_1)
					}
				if(203 to 205){
					E = list(/game/enemy/mole, /game/enemy/mrbubble, /game/enemy/salty/_1)
					}
				if(206 to 208){
					E = list(/game/enemy/gnome, /game/enemy/mole, /game/enemy/salty/_2)
					}
				if(209 to 210){
					E = list(/game/enemy/mobius,/game/enemy/gnome,/game/enemy/mole)
					}
				}
			return E
			}
		}
	pagota{
		icon = 'pagota.dmi'
		var{
			list/ninja = new()
			}
		enemies(wave, boss){
			var/list/E
			switch(wave){
				if( 9 to 12){
					E = list(/game/enemy/ninja/_2, /game/enemy/spearer, /game/enemy/ninja/_1)
					}
				if(13 to 15){
					E = list(/game/enemy/ninja/_2, list(/game/enemy/shinto, /game/enemy/spearer), /game/enemy/ninja/_1)
					}
				if(16 to 18){
					E = list(/game/enemy/ninja/_3, /game/enemy/shinto, /game/enemy/ninja/_2)
					}
				if(19 to 20){
					E = list(/game/enemy/shogun)
					}
				if(139 to 142){
					E = list(/game/enemy/ninja/_2, /game/enemy/spearer, /game/enemy/ninja/_1)
					}
				if(143 to 145){
					E = list(/game/enemy/ninja/_2, list(/game/enemy/shinto, /game/enemy/spearer), /game/enemy/ninja/_1)
					}
				if(146 to 148){
					E = list(/game/enemy/ninja/_3, /game/enemy/shinto, /game/enemy/ninja/_2)
					}
				if(149 to 150){
					E = list(/game/enemy/shogun)
					}
				}
			return E
			}
		}

/*
ruins:: *Skeletons, Skull Knights, Necromancers
Dungeon:: *Skeletons, Knights
Tower:: Knights, Wizards, *Djinn
	*/
