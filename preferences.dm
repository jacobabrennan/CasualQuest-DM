world{
	Del(){
		for(var/client/C){
			C.update_hub()
			C.save_settings()
			}
		. = ..()
		}
	}
client{
	var{
		savefile/save
		}
	New(){
		. = ..()
		var/client_file = Import()
		save = new(client_file)
		load_settings()
		retrieve_scores()
		}
	Del(){
		update_hub()
		save_settings()
		. = ..()
		}
	proc{
		load_settings(){
			// Scores (wave, high score)
			/*
			save.cd = "/"
			if("scores" in save.dir){
				save.cd = "/scores"
				if("high_score" in save.dir){
					save.cd = "/scores/high_score"
					save >> high_score
					}
				save.cd = "/scores"
				if("high_wave" in save.dir){
					save.cd = "/scores/high_wave"
					save >> high_wave
					}
				save.cd = "/scores"
				if("high_waves" in save.dir){
					save.cd = "/scores/high_waves"
					save >> high_waves
					}
				}
				*/
			// Preferences
			var/settings_text = ""
			save.cd = "/"
			if("settings" in save.dir){
				save.cd = "/settings"
				save >> settings_text
				}
			var/list/settings = new()
			if(settings_text){
				for(var/setting in text2list(settings_text, "\n")){
					var/equal = findtext(setting,"="    )
					if(!equal){ continue}
					var/name  = copytext(setting,1,equal)
					var/value = copytext(setting,equal+1)
					settings[name] = value
					}
				}
			spawn(1){
				key_defaults()
				if(settings["primary"]){
					key_editor.primary = settings["primary"]
					register_macro(settings["primary"], PRIMARY)
					}
				if(settings["secondary"]){
					key_editor.secondary = settings["secondary"]
					register_macro(settings["secondary"], SECONDARY)
					}
				if(settings["tertiary"]){
					key_editor.tertiary = settings["tertiary"]
					register_macro(settings["tertiary"], TERTIARY)
					}
				if(settings["quaternary"]){
					key_editor.quaternary = settings["quaternary"]
					register_macro(settings["quaternary"], QUATERNARY)
					}
				if(settings["panic"]){
					key_editor.panic = settings["panic"]
					register_macro(settings["panic"], HELP_KEY)
					}
				if(settings["north"]){
					key_editor.north = settings["north"]
					register_macro(settings["north"], 1)
					}
				if(settings["south"]){
					key_editor.south = settings["south"]
					register_macro(settings["south"], 2)
					}
				if(settings["east"]){
					key_editor.east = settings["east"]
					register_macro(settings["east"], 4)
					}
				if(settings["west"]){
					key_editor.west = settings["west"]
					register_macro(settings["west"], 8)
					}
				}
			}/*
		save_scores(){
			if(!save){
				save = new()
				}
			// Scores (wave, high score)
			save.cd = "/"
			if(!("scores" in save.dir)){
				save.dir.Add("scores")
				}
			save.cd = "/scores"
			if(high_score && !update_score){
				if(!("high_score" in save.dir)){
					save.dir.Add("high_score")
					}
				save.cd = "/scores/high_score"
				save << high_score
				}
			save.cd = "/scores"
			if(high_wave && !update_wave){
				if(!("high_wave" in save.dir)){
					save.dir.Add("high_wave")
					}
				save.cd = "/scores/high_wave"
				save << high_wave
				}
			save.cd = "/scores"
			if(high_waves && !update_waves){
				if(!("high_waves" in save.dir)){
					save.dir.Add("high_waves")
					}
				save.cd = "/scores/high_waves"
				save << high_waves
				}
			}*/
		save_settings(){
			if(!save){
				save = new()
				}
			// Scores (wave, high score)
			//save_scores()
			// Preferences
			save.cd = "/"
			if(!("settings" in save.dir)){
				save.dir.Add("settings")
				}
			save.cd = "/settings"
			var/N = "\n"
			var/settings_text = {"Casual Quest Settings, last saved on: [time2text(world.time,"MMM DD, YYYY")]"}
			settings_text += N+N+{"Key Bindings:"}
			settings_text += N+{"primary=[    key_editor.primary   ]"}
			settings_text += N+{"secondary=[  key_editor.secondary ]"}
			settings_text += N+{"tertiary=[   key_editor.tertiary  ]"}
			settings_text += N+{"quaternary=[ key_editor.quaternary]"}
			settings_text += N+{"panic=[      key_editor.panic     ]"}
			settings_text += N+{"north=[      key_editor.north     ]"}
			settings_text += N+{"south=[      key_editor.south     ]"}
			settings_text += N+{"east=[       key_editor.east      ]"}
			settings_text += N+{"west=[       key_editor.west      ]"}
			save << settings_text
			Export(save)
			}
		}
	}


/*
client{
	proc{
		load_settings(){
			if(!fexists("settings.txt")){
				winset(src,"resolution_finder_window","is-visible=true")
				winset(src,"resolution_finder_window","is-maximized=true")
				var/list/resolution = winget(src,"resolution_finder_label","pos")
				winset(src,"resolution_finder_window","is-visible=false")
				resolution = text2list(resolution,",")
				resolution[1] = text2num(resolution[1])+32
				resolution[2] = text2num(resolution[2])+32
				var/pos_x = resolution[1]/2 - 272
				var/pos_y = resolution[2]/2 - 280
				winset(src,"resolution_finder_window","is-maximized=false")
				winset(src,"main","is-visible=true;pos=[pos_x],[pos_y]")
				key_defaults()
				return FALSE
				}
			var/file_text = file2text("settings.txt")
			var/list/setting_pairs = text2list(file_text,"\n")
			var/list/settings = new()
			for(var/setting in setting_pairs){
				var/equal = findtext(setting,"="    )
				if(!equal){ continue}
				var/name  = copytext(setting,1,equal)
				var/value = copytext(setting,equal+1)
				settings[name] = value
				}
			//if(settings["position"]){ winset(interface.client,WINDOW,"pos=[settings["position"]]")}
			//if(settings["icon_size"]){ interface.skin.resize(settings["icon_size"])}
			//if(settings["full_screen"] == "true"){ interface.skin.resize(-1)}
			winset(src, "main", "is-visible=true")
			spawn(10){
				key_defaults()
				if(settings["primary"]){
					key_editor.primary = settings["primary"]
					register_macro(settings["primary"], "primary")
					}
				if(settings["secondary"]){
					key_editor.secondary = settings["secondary"]
					register_macro(settings["secondary"], "secondary")
					}
				if(settings["tertiary"]){
					key_editor.tertiary = settings["tertiary"]
					register_macro(settings["tertiary"], "tertiary")
					}
				if(settings["quaternary"]){
					key_editor.quaternary = settings["quaternary"]
					register_macro(settings["quaternary"], "quaternary")
					}
				if(settings["panic"]){
					key_editor.secondary = settings["panic"]
					register_macro(settings["panic"], "panic")
					}
				if(settings["north"]){
					key_editor.north = settings["north"]
					register_macro(settings["north"], "1")
					}
				if(settings["south"]){
					key_editor.south = settings["south"]
					register_macro(settings["south"], "2")
					}
				if(settings["east"]){
					key_editor.east = settings["east"]
					register_macro(settings["east"], "4")
					}
				if(settings["west"]){
					key_editor.west = settings["west"]
					register_macro(settings["west"], "8")
					}
				}
			return TRUE
			}
		save_settings(){
			var/N = "\n"
			var/settings_text = {"Casual Quest Settings, last saved on: [time2text(world.time,"MMM DD, YYYY")]"}
			var/icon_size = winget(src, "main", "size")
			switch(icon_size){
				if("272x240"){ icon_size = "small"}
				if("544x480"){ icon_size = "large"}
				if("816x720"){ icon_size = "3x"}
				if("1088x960"){ icon_size = "4x"}
				}
			settings_text += N+N+{"Window:"}
			settings_text += N+{"icon_size=[icon_size]"}
			settings_text += N+{"full_screen=[winget(src, "main", "is-maximized")]"}
			settings_text += N+{"position=[winget(src, "main", "pos")]"}
			settings_text += N+N+{"Key Bindings:"}
			settings_text += N+{"primary=[    key_editor.primary   ]"}
			settings_text += N+{"secondary=[  key_editor.secondary ]"}
			settings_text += N+{"tertiary=[   key_editor.tertiary  ]"}
			settings_text += N+{"quaternary=[ key_editor.quaternary]"}
			settings_text += N+{"panic=[      key_editor.panic     ]"}
			settings_text += N+{"north=[      key_editor.north     ]"}
			settings_text += N+{"south=[      key_editor.south     ]"}
			settings_text += N+{"east=[       key_editor.east      ]"}
			settings_text += N+{"west=[       key_editor.west      ]"}
			//settings_text +=
			if(fexists("settings.txt")){ fdel("settings.txt")}
			text2file(settings_text, "settings.txt")
			}
		}
	}
	*/