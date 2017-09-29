proc{
	aloc(atom/what){
		if(!istype(what,/atom)){ return null}
		var/atom/current_loc = what
		while(!isarea(current_loc)){
			if(!current_loc.loc){ return null}
			current_loc = current_loc.loc
			}
		return current_loc
		}
	}
proc{
	sign(N){
		if(!N   ){ return  0}
		if(N > 0){ return  1}
		if(N < 0){ return -1}
		}
	ceil(N){
		return -round(-N)
		}
	}
proc{
	arctan(x, y){ // corresponds to standard x=cos, y=sin mapping
		// tangent is y/x
		if(!x && !y) return 0 // the only special case
		var/a = arccos(x/sqrt(x*x+y*y))
		return (y>=0)?(a):(-a+360)
		}
	}
proc{
	ceiling(N){
		return -round(-N)
		}
	}
proc{
	coord(x, y){
		return new /coord(x,y)
		}
	}
coord{
	var{
		x = 0
		y = 0
		}
	New(_x, _y){
		.=..()
		x = _x
		y = _y
		}
	proc{
		Copy(){
			return new /coord(x,y)
			}
		}
	}










proc{
	text2list(text, separator){
		var/textlength      = lentext(text)
		var/separatorlength = lentext(separator)
		var/list/textList   = new /list()
		var/searchPosition  = 1
		var/findPosition    = 1
		var/buggyText
		while(1){
			findPosition = findtextEx(text, separator, searchPosition, 0)
			buggyText = copytext(text, searchPosition, findPosition)
			textList += "[buggyText]"
			searchPosition = findPosition + separatorlength
			if(findPosition == 0){
				return textList
				}
			else if(searchPosition > textlength){
				//textList += ""
				return textList
				}
			}
		}
	list2text(var/list/the_list, separator){
		var/total = the_list.len
		if(total == 0){
			return
			}
		var/newText = "[the_list[1]]"
		for(var/count = 2, count <= total, count++){
			if(separator){
				newText += separator
				}
			newText += "[the_list[count]]"
			}
		return newText
		}
	}