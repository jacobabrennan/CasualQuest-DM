#ifdef DEBUG
client
	verb
		dump_documentation()
			set name = ".docudump"
			set hidden = 1

			var/list/paths = list()

			for(var/combo in game.subscriber_archetypes)
				// Get the classes attached to that combo
				var/list/classes = game.subscriber_archetypes[combo]
				if(!istype(classes, /list)) classes = list(classes)

				// Add each type (only once) to the paths list
				for(var/path in classes)
					paths[path] = null

			for(var/combo in game.hero_archetypes)
				// Get the classes attached to that combo
				var/list/classes = game.subscriber_archetypes[combo]
				if(!istype(classes, /list)) classes = list(classes)

				// Add each type (only once) to the paths list
				for(var/path in classes)
					paths[path] = null

			var/text = ""
			for(var/path in paths)
				var/game/hero/H = new path(null)
				text += "\n\n<!-------------- ([path]) ---------- -->\n\n"
				text += H.to_html(FALSE)

			text = "<html><title>Class Description</title>[hero_html_script]<body>[text]</body></html>"

			if(fexists("docudump.html"))
				fdel("docudump.html")

			text2file(text, "docudump.html")
#endif