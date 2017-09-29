mob
	Login()
		client.skin = new(client)
		..()

client
	var
		client/skin/skin
		is_chat_visible = TRUE

	Topic(href,href_list[])
		switch(href_list["action"])
			if("class_info")
				show_class(href_list["class"])

			if("show_help")
				src.help()
	
	proc
		IsUsingWebclient()
			while(!connection) sleep 1
			return connection == "web"

	verb
		web_link(where as text)
			set name = ".link"
			src << link(where)

		toggle_menu()
			set name = ".togglemenu"
			if(IsUsingWebclient()) return
			var/menu = winget(src, MAIN, "menu")
			if(menu)
				winset(src, MAIN, "menu")

			else
				winset(src, MAIN, "menu=main_menu;")

		display_size(factor as num)
			set name = ".displaysize"
			if(IsUsingWebclient()) return
			if(factor == -1)
				if(winget(src, MAIN, "is-maximized") == "true")
					winset(src, MAIN, "is-maximized='false';")

				else
					winset(src, MAIN, "is-maximized='true';")


			else
				var/x_size = (factor * TILE_WIDTH  * world.maxx) + 4 // 4px border
				var/y_size = (factor * TILE_HEIGHT * world.maxy) + 4 // 4px border
				winset(src, MAIN, "size=[x_size]x[y_size]")

		help()
			set name = ".help"
			winshow(src, "help")
			skin.center_window("help")
			src << browse('help.html')

		toggle_chat()
			set name = ".togglechat"
			is_chat_visible = !is_chat_visible
			winshow(src, "chat", is_chat_visible)

		card(which in list(1,2))
			set name = ".card"
			if(game.stage != STAGE_WIN){ return}
			if(!game.map.card){ return}
			if(src in game.map.card.choosers){ return}
			if(game.map.card && hero)
				game.map.card.choosers.Add(src)
				game.map.card.choose(hero, which)

			skin.hide_card()
			winset(src, null, "main.notify.left='notify_wait'; main.notify.is-visible='false';")

		custom()
			set name = ".custom"
			if(game.stage != STAGE_WIN){ return}
			if(!game.map.card){ return}
			if(src in game.map.card.choosers){ return}
			if(game.map.card && hero)
				var/custom_path = text2path("/game/hero/custom/[ckey]")
				var/hero_level = hero.level_knight + hero.level_priest + hero.level_mage + hero.level_rogue
				if(custom_path && hero && hero_level >= 3)
					game.map.card.choosers.Add(src)
					game.add_hero(src, custom_path)
					skin.hide_card()
					winset(src, null, "main.notify.left='notify_wait'; main.notify.is-visible='false';")

		focus_chat()
			set name = ".focuschat"
			var/chat = winget(src, "chat", "is-visible")
			var/visi = winget(src, "chat.input", "focus")
			if(chat != "true")
				winshow(src, "chat")

			if(visi == "true")
				winset(src, null, "main.focus='true';")

			else
				winset(src, null, "chat.input.focus='true';")


client/skin{
	parent_type = /datum
	var{
		client/client
		res_width
		res_height
		}
	New(var/client/_client){
		client = _client
		determine_resolution()
		debug_menu()
		// center_window(MAIN)
		winset(client, MAIN, "focus=true;")
		hide_card()
		}
	proc{
		debug_menu()
			#ifdef DEBUG
			winset(client, "debugmenu", "parent=main_menu;name=Debug")
			winset(client, "debugmessages","parent=debugmenu;name=\"Messages\";command=\".options\"")
			winset(client, "debugcommand","parent=debugmenu;name=\"Command\";command=\".command\"")
			#endif
		determine_resolution(){
			if(client.IsUsingWebclient()){
				var size[] = splittext(winget(client, "main", "size"), "x")
				res_width = text2num(size[1])
				res_height = text2num(size[2])
				}
			else {
				winset(client, "resolution_finder_window", "is-visible=true;is-maximized=true")
				var/resolution = winget(client, "resolution_finder_label", "pos")
				winset(client, "resolution_finder_window", "is-visible=false;is-maximized=false")
				var/comma_pos = findtext(resolution, ",")
				res_width  = text2num(copytext(resolution, 1, comma_pos))+32
				res_height = text2num(copytext(resolution, comma_pos +1))+32
				}
			}
		center_window(window_handle){
			var/size = winget(client, window_handle, "size")
			var/x_pos = findtext(size, "x")
			var/size_x = text2num(copytext(size, 1, x_pos))
			var/size_y = text2num(copytext(size, x_pos +1))
			var/new_x = round((res_width  - size_x)/2)
			var/new_y = round((res_height - size_y)/2)-50
			winset(client, window_handle, "pos=[new_x],[new_y];")
			}
		notify_wait(){
			var/wintext = "main.notify.left='notify_wait'; main.notify.is-visible='true';"
			winset(client, null, wintext)
			spawn(){
				sleep(60)
				if(client){
					wintext = "main.notify.is-visible='false';"
					winset(client, null, wintext)
					}
				}
			}
		notify_spectate(){
			hide_card()
			var/wintext = "main.notify.left='notify_spectate'; main.notify.is-visible='true';"
			winset(client, null, wintext)
			spawn(){
				sleep(60)
				if(client){
					wintext = "main.notify.is-visible='false';"
					winset(client, null, wintext)
					}
				}
			}
		show_card(var/game/card/_card){
			var/card_pane = "card"
			var/custom_path = text2path("/game/hero/custom/[client.ckey]")
			var/hero_level = client.hero.level_knight + client.hero.level_priest + client.hero.level_mage + client.hero.level_rogue
			if(custom_path && client.hero && hero_level >= 3){
				card_pane = "custom_card"
				}
			var/wintext = {""}
			wintext += "[card_pane].card_image.image='[_card.file]';"
			wintext += "[card_pane].card_info.text='[_card.description]';"
			wintext += "[card_pane].card_option1.text='[_card.option1]';"
			wintext += "[card_pane].card_option2.text='[_card.option2]';"
			wintext += "card_display.left='[card_pane]';"
			winset(client, null, wintext)
			wintext =  "card_display.is-visible='true';"
			//wintext += "card.focus='true';"
			winset(client, null, wintext)
			}
		hide_card(){
			var/wintext = {""}
			wintext += "card_display.is-visible='false';"
			//wintext += "main.focus='true';"
			winset(client, null, wintext)
			}
		hide_award(){
			winset(client, null, "main.notify.left='award'; main.notify.is-visible='false';")
			}
		award(which){
			switch(which){
				if(1){
					winset(client, null, {"award_image.image='['award_1.png']'; award_info.text='[AWARD_1]';"})
					spawn(){ world.SetMedal("Queen's Emerald", client)}
					}
				if(2){
					winset(client, null, {"award_image.image='['award_2.png']'; award_info.text='[AWARD_2]';"})
					spawn(){ world.SetMedal("Ancient Tome", client)}
					}
				if(3){
					winset(client, null, {"award_image.image='['award_3.png']'; award_info.text='[AWARD_3]';"})
					spawn(){ world.SetMedal("Moon Stone", client)}
					}
				if(4){
					winset(client, null, {"award_image.image='['award_4.png']'; award_info.text='[AWARD_4]';"})
					spawn(){ world.SetMedal("Isis Mirror", client)}
					}
				if(5){
					winset(client, null, {"award_image.image='['award_5.png']'; award_info.text='[AWARD_5]';"})
					spawn(){ world.SetMedal("Charm of Chanji", client)}
					}
				if(6){
					winset(client, null, {"award_image.image='['award_6.png']'; award_info.text='[AWARD_6]';"})
					spawn(){ world.SetMedal("Staff of Kyamites", client)}
					}
				if(7){
					winset(client, null, {"award_image.image='['award_7.png']'; award_info.text='[AWARD_7]';"})
					spawn(){ world.SetMedal("Singing Harp", client)}
					}
				if(8){
					winset(client, null, {"award_image.image='['award_8.png']'; award_info.text='[AWARD_8]';"})
					spawn(){ world.SetMedal("Bearly Made It", client)}
					}
				}
			winset(client, null, "main.notify.left='award'; main.notify.is-visible='true';")
			}
		}
	}
client/skin/title_screen{
	parent_type = /obj
	icon = 'title.png'
	}
client/skin/game_over{
	parent_type = /obj
	icon = 'game_over.png'
	}
client/skin/wave_complete{
	parent_type = /obj
	icon = 'wave_complete.png'
	layer = MOB_LAYER+2
	New(){
		. = ..()
		tag = "wave_complete"
		}
	}
client/skin/wave_text{
	parent_type = /obj
	icon = 'rectangles.dmi'
	layer = MOB_LAYER+1
	}