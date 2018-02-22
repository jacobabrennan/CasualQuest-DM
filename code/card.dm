/*

Knight
+ : ............
- : ......

Priest
+ : .........
- : .....

Mage
+ : .............
- : ......

Rogue
+ : ............
- : ........

	*/

/*
Name
Tier
Knight Level
Priest Level
Mage   Level
Rogue  Level
Max Health
Max Aura
Aura Rate
Speed
Main Attack
Skill1
Skill2
Skill3
Notes
	*/


//------------------------------------------------------------------------------

proc
	convert_path_to_class(path)
		var
			index = 0
			lastSlash = 0
		do
			index = findtextEx(path, index+1)
			if(index) lastSlash = index
		while(index)

		return copytext(path, lastSlash+1)
		/*
		var new_pos = findtext(class,"/",(pos+1))
		if(new_pos>pos)
			return convert_path_to_class(class,new_pos)
		else if(new_pos<pos)
			return copytext(class,(pos+1))
		else
			return copytext(class,(new_pos+1))
		*/

game/hero
	var
		tier = 1

game/card
	parent_type = /datum
	var
		description
		file = 'sign.png'
		option1 = "Yes (1)"
		option2 = "No (2)"
		list/choosers = new()

	proc

		choose(var/game/hero/H, which)

		transform(var/game/hero/H, knight, priest, mage, rogue)
			var level_max = H.level_knight + H.level_priest + H.level_mage + H.level_rogue;
			var level_knight = max(0, min(3, H.level_knight + knight))
			var level_priest = max(0, min(3, H.level_priest + priest))
			var level_mage   = max(0, min(3, H.level_mage   + mage  ))
			var level_rogue  = max(0, min(3, H.level_rogue  + rogue ))
			if(level_max >= 4)
				level_knight = max(0, min(3, knight))
				level_priest = max(0, min(3, priest))
				level_mage   = max(0, min(3, mage  ))
				level_rogue  = max(0, min(3, rogue ))
			var class_level = "[level_knight][level_priest][level_mage][level_rogue]"
			var class_path
			var /client/H_client = H.player
			if(istype(H_client))
				var /game/hero/lich/skeleton/_skeleton = H
				if(istype(_skeleton))
					class_path = _skeleton.hero_type
				else if(H_client.subscription)
					class_path = game.subscriber_archetypes[class_level]
				else
					class_path = game.hero_archetypes[class_level]
				if(istype(class_path, /list))
					var /list/classes = class_path
					classes.Remove(H.type)
					if(classes.len)
						class_path = pick(classes)
					else
						class_path = null
			if(class_path == H.type || !class_path)
				var tier = H.level_knight + H.level_priest + H.level_mage + H.level_rogue
				switch(tier)
					if(0,1,4) return
					if(2)
						var /list/classes = list(
							/game/hero/dragoon,
							/game/hero/paladin,
							/game/hero/dark_knight,
							/game/hero/barbarian,
							/game/hero/cleric,
							/game/hero/druid,
							/game/hero/bard,
							/game/hero/wizard,
							/game/hero/nomad,
							/game/hero/pirate,
						)
						classes.Remove(H.type)
						class_path = pick(classes)
			if(!class_path) return
			/*
			var topic_path = convert_path_to_class("[class_path]")
			if(ckey(topic_path)=="lich") { topic_path="Necromancer"}
			else if(ckey(topic_path)=="rebel") { topic_path="Revolutionary"}
			else if(ckey(topic_path)=="assassin") { topic_path="Ninja"}
			else if(ckey(topic_path)=="blank") { topic_path="Adventurer"}
			else if(ckey(topic_path)=="member") { topic_path="Member's Adventurer"}
			for(var/game/hero/class_match) {
				if(ckey(class_match.name) == ckey(topic_path)) { topic_path = class_match.name;break}
				}
			*/
			var/client/switching_player = H.player
			game.add_hero(switching_player, class_path)
			switching_player.hero.output_class_link(world, switching_player)
