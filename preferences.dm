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
			}
		save_settings(){
			if(!save){
				save = new()
				}
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
