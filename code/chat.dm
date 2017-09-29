client{
	verb{
		chat(what as text|null){
			what = html_encode(what)
			what = copytext(what, 1, findtext(what, "\n"))
			what = {"<b class="user_name">[html_encode(key)]</b>: [what]"}
			if(hero){
				var/image_link = hero.to_link({"<img class="icon" src="\ref[hero.icon]" icondir="EAST" iconframe="2" border="0">"})
				what = "[image_link] [what]"
				}
			world << what
			}
		}
	}