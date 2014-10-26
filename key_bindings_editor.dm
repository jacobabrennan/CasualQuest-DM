#define MACRO_BACK "BACK"
#define MACRO_TAB "TAB"
#define MACRO_RETURN "RETURN"
#define MACRO_NORTH "NORTH"
#define MACRO_NORTHEAST "NORTHEAST"
#define MACRO_NORTHWEST "NORTHWEST"
#define MACRO_SOUTH "SOUTH"
#define MACRO_SOUTHEAST "SOUTHEAST"
#define MACRO_SOUTHWEST "SOUTHWEST"
#define MACRO_CENTER "CENTER"
#define MACRO_EAST "EAST"
#define MACRO_WEST "WEST"
#define MACRO_SPACE "SPACE"
#define MACRO_APPS "APPS"
#define MACRO_DELETE "DELETE"
#define MACRO_INSERT "INSERT"
#define MACRO_PAUSE "PAUSE"
#define MACRO_DIVIDE "DIVIDE"
#define MACRO_MULTIPLY "MULTIPLY"
#define MACRO_ADD "ADD"
#define MACRO_SUBTRACT "SUBTRACT"
#define MACRO_ESCAPE "ESCAPE"

client{
	var{
		client/key_editor/key_editor
		}
	New(){
		. = ..()
		key_editor = new(src)
		}
	verb{
		open_key_editor(){
			set name = ".open_key_editor"
			set hidden = TRUE
			var/winset_text = {""}
			winset_text += "key_binding_primary.text=[    key_editor.primary   ];"
			winset_text += "key_binding_secondary.text=[  key_editor.secondary ];"
			winset_text += "key_binding_tertiary.text= [  key_editor.tertiary  ];"
			winset_text += "key_binding_quaternary.text=[ key_editor.quaternary];"
			winset_text += "key_binding_panic.text=[      key_editor.panic     ];"
			winset_text += "key_binding_north.text=[      key_editor.north     ];"
			winset_text += "key_binding_south.text=[      key_editor.south     ];"
			winset_text += "key_binding_east.text=[       key_editor.east      ];"
			winset_text += "key_binding_west.text=[       key_editor.west      ];"
			winset(src, null, winset_text)
			skin.center_window("key_editor")
			winshow(src, "key_editor")
			}
		key_defaults(){
			set name = ".default_keys"
			key_editor.primary    = initial(key_editor.primary   )
			key_editor.secondary  = initial(key_editor.secondary )
			key_editor.tertiary   = initial(key_editor.tertiary )
			key_editor.quaternary = initial(key_editor.quaternary)
			key_editor.panic      = initial(key_editor.panic     )
			key_editor.north      = initial(key_editor.north     )
			key_editor.south      = initial(key_editor.south     )
			key_editor.east       = initial(key_editor.east      )
			key_editor.west       = initial(key_editor.west      )
			var/winset_text = {""}
			winset_text += "key_binding_primary.text=[    key_editor.primary    ];"
			winset_text += "key_binding_secondary.text=[  key_editor.secondary  ];"
			winset_text += "key_binding_tertiary.text= [  key_editor.tertiary   ];"
			winset_text += "key_binding_quaternary.text=[ key_editor.quaternary ];"
			winset_text += "key_binding_panic.text=[      key_editor.panic      ];"
			winset_text += "key_binding_north.text=[      key_editor.north      ];"
			winset_text += "key_binding_south.text=[      key_editor.south      ];"
			winset_text += "key_binding_east.text=[       key_editor.east       ];"
			winset_text += "key_binding_west.text=[       key_editor.west       ];"
			winset(src, null, winset_text)
			register_macro(key_editor.primary   , PRIMARY   )
			register_macro(key_editor.secondary , SECONDARY )
			register_macro(key_editor.tertiary  , TERTIARY  )
			register_macro(key_editor.quaternary, QUATERNARY)
			register_macro(key_editor.panic     , HELP_KEY  )
			register_macro(key_editor.north     , 1         )
			register_macro(key_editor.south     , 2         )
			register_macro(key_editor.east      , 4         )
			register_macro(key_editor.west      , 8         )
			}
		register_key(what as text){
			set name = ".register_key"
			set hidden = TRUE
			if(what == MACRO_ESCAPE){
				var/winset_text = {""}
				for(var/window_id in list("key_editor","main","help","chat")){
					winset_text += "[window_id].is-disabled=false;"
					}
				winset_text += "key_capture.is-visible=false;"
				winset(src, null, winset_text)
				return
				}
			key_editor.register_key(what)
			}
		apply_key_bindings(){
			set name = ".apply_key_bindings"
			set hidden = TRUE
			winshow(src, "key_editor", FALSE)
			save_settings()
			}
		find_key(which as text){
			set name = ".find_key"
			set hidden = TRUE
			key_editor.key_waiting = which
			skin.center_window("key_capture")
			var/winset_text = {""}
			for(var/window_id in list("key_editor","main","help","chat")){
				winset_text += "[window_id].is-disabled=false;"
				}
			winset_text += "key_capture.is-visible=true;"
			winset(src, null, winset_text)
			}
		}
	proc{
		register_macro(which_key, which_command){
			var/list/params_down = new()
			var/list/params_up   = new()
			if(!winexists(src, "macro_down_[which_command]")){
				params_down["parent"] = "macro"
				params_up[  "parent"] = "macro"
				}
			params_down["name"   ] = which_key
			params_up[  "name"   ] = which_key+"+UP"
			params_down["command"] = {"key_down [which_command]"}
			params_up[  "command"] = {"key_up [which_command]"}
			winset(src, "macro_down_[which_command]", list2params(params_down))
			winset(src, "macro_up_[  which_command]", list2params(params_up  ))
			/*if(which_command in list("1","2","4","8",1,2,4,8)){
				//params_down["name"] = which_key+"+REP"
				//winset(src, "macro_down_[which_command]", list2params(params_down))
				register_macro("SHIFT+[which_key]", SHIFT|text2num(which_command))
				}*/
			if(which_command == PRIMARY){
				register_macro("SHIFT+[which_key]", SHIFT_PRIMARY)
				}
			}
		}
	key_editor{
		parent_type = /datum
		New(var/client/_client){
			. = ..()
			client = _client
			}
		var{
			client/client
			primary = MACRO_SPACE
			secondary = "z"
			tertiary = "x"
			quaternary = "c"
			panic = "v"
			north = MACRO_NORTH
			south = MACRO_SOUTH
			east = MACRO_EAST
			west = MACRO_WEST
			key_waiting
			global/macros = list(
				MACRO_DELETE, MACRO_INSERT, MACRO_PAUSE,

				"`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", MACRO_BACK,
				MACRO_TAB, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "\[", "]", "\\",
				"a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", MACRO_RETURN,
				"z", "x", "c", "v", "b", "n", "m", ",", ".", "/",
				MACRO_SPACE, MACRO_APPS,

				MACRO_DIVIDE, MACRO_MULTIPLY, MACRO_SUBTRACT,
				MACRO_NORTHWEST, MACRO_NORTH, MACRO_NORTHEAST, MACRO_ADD,
				MACRO_WEST, MACRO_CENTER, MACRO_EAST,
				MACRO_SOUTHWEST, MACRO_SOUTH, MACRO_SOUTHWEST,
				)
			}
		proc{
			register_key(what){
				for(var/window_id in list("key_editor","main_window","sound_options")){
					winset(client, window_id, "is-disabled=false;")
					}
				winshow(client, "key_capture", FALSE)
				switch(key_waiting){
					if("primary"){
						primary = what
						winset(client, "key_binding_primary", "text=[what]")
						client.register_macro(what, PRIMARY)
						}
					if("secondary"){
						secondary = what
						winset(client, "key_binding_secondary", "text=[what]")
						client.register_macro(what, SECONDARY)
						}
					if("tertiary"){
						tertiary = what
						winset(client, "key_binding_tertiary", "text=[what]")
						client.register_macro(what, TERTIARY)
						}
					if("quaternary"){
						quaternary = what
						winset(client, "key_binding_quaternary", "text=[what]")
						client.register_macro(what, QUATERNARY)
						}
					if("panic"){
						panic = what
						winset(client, "key_binding_panic", "text=[what]")
						client.register_macro(what, HELP_KEY)
						}
					if("1"){
						north = what
						winset(client, "key_binding_north", "text=[what]")
						client.register_macro(what, "1")
						}
					if("2"){
						south = what
						winset(client, "key_binding_south", "text=[what]")
						client.register_macro(what, "2")
						}
					if("4"){
						east = what
						winset(client, "key_binding_east", "text=[what]")
						client.register_macro(what, "4")
						}
					if("8"){
						west = what
						winset(client, "key_binding_west", "text=[what]")
						client.register_macro(what, "8")
						}
					}
				}
			}
		}
	}