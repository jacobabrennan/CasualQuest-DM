

//-- Region --------------------------------------------------------------------

game/map/region
	parent_type = /datum
	var
		icon
		list/weak_enemies
		list/medium_enemies
		list/strong_enemies
		list/bosses

	proc
		enemies(wave, boss)
			var/list/E = new()
			var/weak_index   = min(  weak_enemies.len, max(1, 1+round((wave + 17) / 21)))
			var/medium_index = min(medium_enemies.len, max(1, 1+round((wave - 11) / 21)))
			var/strong_index = min(strong_enemies.len, max(1, 1+round((wave +  4) / 21)))
			var/list/strong
			if(boss)
				var/boss_index = min(bosses.len, max(1, round((wave+1)/20)))
				strong = bosses[boss_index]
			else
				strong = strong_enemies[strong_index]
			if(istype(strong))
				strong = pick(strong)
			E.Add(strong)
			var/list/medium = medium_enemies[medium_index]
			if(istype(medium))
				medium = pick(medium)
			E.Add(medium)
			var/list/weak = weak_enemies[weak_index]
			if(istype(weak))
				weak = pick(weak)
			E.Add(weak)
			return E
