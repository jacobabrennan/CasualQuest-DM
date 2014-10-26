game{
	var{
		list/meters = new(METER_WIDTH)
		list/meters_magic = new(METER_WIDTH)
		image/help_overlay
		}
	New(){
		var/obj/temp_o = new()
		var/image/help = image('rectangles.dmi', null, "help", MOB_LAYER+1)
		help.pixel_y += TILE_HEIGHT
		temp_o.overlays.Add(help)
		for(var/appearance in temp_o.overlays){
			help_overlay = appearance
			}
		del temp_o
		for(var/I = 1 to METER_WIDTH){
			var/obj/temp = new()
			var/image/proto_app = image('meter.dmi', null, "[I]", MOB_LAYER)
			proto_app.pixel_y = TILE_HEIGHT+1
			temp.overlays.Add(proto_app)
			for(var/appearance in temp.overlays){
				meters[I] = appearance
				}
			del temp
			}
		for(var/I = 1 to METER_WIDTH){
			var/obj/temp = new()
			var/image/proto_app = image('meter_magic.dmi', null, "[I]", MOB_LAYER)
			proto_app.pixel_y = TILE_HEIGHT+3
			temp.overlays.Add(proto_app)
			for(var/appearance in temp.overlays){
				meters_magic[I] = appearance
				}
			del temp
			}
		. = ..()
		}
	}