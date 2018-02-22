

//-- Skills --------------------------------------------------------------------

skill {}
game/hero/skill
	parent_type = /skill
	var game/hero/owner, name, description={""}, potency
	proc
		activate()
	New(var/game/hero/_owner)
		. = ..()
		owner = _owner
