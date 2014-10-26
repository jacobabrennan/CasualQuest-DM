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

game/card{
	parent_type = /datum
	var{
		description
		file = 'sign.png'
		option1 = "Yes (1)"
		option2 = "No (2)"
		list/choosers = new()
		}
	proc{
		choose(var/game/hero/H, which){
			}
		transform(var/game/hero/H, knight, priest, mage, rogue){
			var/level_max = H.level_knight + H.level_priest + H.level_mage + H.level_rogue;
			var/level_knight = max(0, min(3, H.level_knight + knight))
			var/level_priest = max(0, min(3, H.level_priest + priest))
			var/level_mage   = max(0, min(3, H.level_mage   + mage  ))
			var/level_rogue  = max(0, min(3, H.level_rogue  + rogue ))
			if(level_max >= 4){
				level_knight = max(0, min(3, knight))
				level_priest = max(0, min(3, priest))
				level_mage   = max(0, min(3, mage  ))
				level_rogue  = max(0, min(3, rogue ))
				}
			var/class_level = "[level_knight][level_priest][level_mage][level_rogue]"
			var/class_path
			var/client/H_client = H.player
			if(istype(H_client)){
				var/game/hero/lich/skeleton/_skeleton = H
				if(istype(_skeleton)){
					class_path = _skeleton.hero_type
					}
				else if(H_client.subscription){
					class_path = game.subscriber_archetypes[class_level]
					}
				else{
					class_path = game.hero_archetypes[class_level]
					}
				if(istype(class_path, /list)){
					var/list/classes = class_path
					classes.Remove(H.type)
					if(classes.len){
						class_path = pick(classes)
						}
					else{
						class_path = null
						}
					}
				}
			if(class_path == H.type || !class_path){
				var/tier = H.level_knight + H.level_priest + H.level_mage + H.level_rogue
				switch(tier){
					if(0,1,4){ return}
					if(2){
						var/list/classes = list(
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
						}
					}
				}
			if(!class_path){ return}
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
			}
		}
	card_1{
		file = 'fortune_teller.png'
		description = "On your way you happen upon a fortune teller. Do you stop and get your fortune told?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0, 1, 0)
					}
				if(2){
					transform(H, 0, 1,-1, 0)
					}
				}
			}
		}
	card_2{
		file = 'fortune_teller.png'
		description = "On your way you happen upon a fortune teller. Do you believe in her prophesies?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H,-1, 1, 0, 0)
					}
				if(2){
					transform(H, 1,-1, 0, 0)
					}
				}
			}
		}
	card_3{
		file = 'fortune_teller.png'
		description = "You find a boisterous hag rambling about treasured secrets. Do you stop and listen?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0, 0, 1)
					}
				if(2){
					transform(H, 0, 1, 0,-1)
					}
				}
			}
		}
	card_4{
		file = 'sign.png'
		description = "In your way there is an ominous sign telling of danger ahead. Do you take another route?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H,-1, 0, 0, 1)
					}
				if(2){
					transform(H, 1, 0, 0, 0)
					}
				}
			}
		}
	card_5{
		weight_1{}
		weight_2{}
		file = 'sign.png'
		description = "There is a shipwreck with a sign in front of it. It warns of death inside. Do you go in?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0,-1, 0, 1)
					}
				if(2){
					transform(H, 0, 0, 1,-1)
					}
				}
			}
		}
	card_6{
		file = 'sign.png'
		description = "You need water and there is a lake ahead. A sign tells of danger. Do you go for water or leave?"
		option1 = "Water (1)"
		option2 = "Leave (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0, 1,-1)
					}
				if(2){
					transform(H,-1, 0, 0, 1)
					}
				}
			}
		}
	card_8{
		file = 'split.png'
		description = "You are tired and encounter a sign telling of lodging. It is off your route. Do you take it?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0, 1,-1)
					}
				if(2){
					transform(H, 0, 0,-1, 1)
					}
				}
			}
		}
	card_10{
		file = 'treasure.png'
		description = "You find a treasure chest. Do you have your friends help disarm it and share the gold, or do you chance it and take it all?"
		option1 = "Take (1)"
		option2 = "Share (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0,-1, 0, 1)
					}
				if(2){
					transform(H, 0, 1, 0,-1)
					}
				}
			}
		}
	card_12{
		file = 'treasure.png'
		description = "On your way you find a monkey sleeping on a chest up on a ledge. Do you throw rocks?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0,-1, 0, 1)
					}
				if(2){
					transform(H, 0, 1, 0,-1)
					}
				}
			}
		}
	card_13{
		file = 'cave.png'
		description = "There is a mountain in your way with a cave at the base of it. Do you take the cave or the mountain pass?"
		option1 = "Cave (1)"
		option2 = "Pass (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0, 1, 0)
					}
				if(2){
					transform(H, 1, 0, 0, 0)
					}
				}
			}
		}
	card_14{
		file = 'cave.png'
		description = "You are hungry and the cave in front of you looks as if there is wild life inside. Do you go hunting in the cave or move on?"
		option1 = "Hunt (1)"
		option2 = "Leave (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 1, 0,-1, 0)
					}
				if(2){
					transform(H, 0, 0, 1, 0)
					}
				}
			}
		}
	card_15{
		file = 'traveller.png'
		description = "On the road you find a traveler. He is asking for assistance. Do you help him?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 1, 0,-1)
					}
				if(2){
					transform(H, 0,-1, 0, 1)
					}
				}
			}
		}
	card_16{
		file = 'traveller.png'
		description = "On the road you find a skilled traveler of this area. Do you ask for his help?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0, 1, 0)
					}
				if(2){
					transform(H, 1, 0, 0, 0)
					}
				}
			}
		}
	card_17{
		file = 'traveller.png'
		description = "There is a man demanding money to use his road. Do you call him a fool or pay his toll."
		option1 = "Pay (1)"
		option2 = "Laugh (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 1, 0, 0, 0)
					}
				if(2){
					transform(H,-1, 0, 0, 1)
					}
				}
			}
		}
	card_18{
		file = 'lightning.png'
		description = "A storm is forming up ahead. Do you make camp or continue on?"
		option1 = "Camp (1)"
		option2 = "Leave (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 1,-1, 0)
					}
				if(2){
					transform(H, 0, 0, 1, 0)
					}
				}
			}
		}
	card_19{
		file = 'lightning.png'
		description = "A storm has forced you to change your course. Do you head to the forest or into a cave?"
		option1 = "Forest (1)"
		option2 = "Cave (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H,-1, 1, 0, 0)
					}
				if(2){
					transform(H, 0, 0, 1,-1)
					}
				}
			}
		}
	card_20{
		file = 'lightning.png'
		description = "There is a foreboding cloud forming above a single cottage. Do you investigate?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H,-1, 0, 1, 0)
					}
				if(2){
					transform(H, 0, 0,-1, 1)
					}
				}
			}}
	card_21{
		file = 'camp_fire.png'
		description = "You stumble upon an empty camp site. Do you use it or leave?"
		option1 = "Use (1)"
		option2 = "Leave (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0,-1, 1)
					}
				if(2){
					transform(H, 1, 0, 0, 0)
					}
				}
			}
		}
	card_22{
		file = 'camp_fire.png'
		description = "You are ready to make camp. Do you make it near the road or head away to a more private spot?"
		option1 = "Road (1)"
		option2 = "Private (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 1, 0, 0, 0)
					}
				if(2){
					transform(H, 0, 0, 0, 1)
					}
				}
			}
		}
	card_23{
		file = 'camp_fire.png'
		description = "There is a man offering to share his camp site with you. Do you accept?"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 1, 0, 0, 0)
					}
				if(2){
					transform(H, 0, 0, 1, 0)
					}
				}
			}
		}
	card_24{
		file = 'swamp_woman.png'
		description = "There is a woman being thrown into quick sand by two men. Do you help her first or deal with the two men?"
		option1 = "Help (1)"
		option2 = "Fight (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 1, 0, 0)
					}
				if(2){
					transform(H, 1, 0, 0, 0)
					}
				}
			}
		}
	card_25{
		file = 'swamp_woman.png'
		description = "There is a large group of people screaming and running away from a woman in a pit. Do you help her or stay away?"
		option1 = "Help (1)"
		option2 = "Leave (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 1,  0, 0, 0)
					}
				if(2){
					transform(H, 0, -1, 1, 0)
					}
				}
			}
		}
	card_26{
		file = 'swamp_woman.png'
		description = "There is a statue of a woman in a sand pit. Do you touch it’s outreached hand or walk away?"
		option1 = "Touch (1)"
		option2 = "Leave (2)"
		choose(var/game/hero/H, which){
			switch(which){
				if(1){
					transform(H, 0, 0, 1, 0)
					}
				if(2){
					transform(H, 1, 0, 0, 0)
					}
				}
			}
		}
	card_gnome{
		file = 'gnome.png'
		description = "Gone Fishing"
		option1 = "Stawberry!"
		option2 = "Blueberry!"
		choose(var/game/hero/H, which){
			var/client/C = H.player
			switch(which){
				if(1){
					game.add_hero(H.player, /game/hero/gnome/red)
					}
				if(2){
					game.add_hero(H.player, /game/hero/gnome/blue)
					}
				}
			if(istype(C)){
				C << {"<img class="icon" src="\ref[C.hero.icon]" icondir="EAST" iconframe="2"><b>Attack your Friends for Fun and Profit!</b>"}
				}
			}
		}
	}