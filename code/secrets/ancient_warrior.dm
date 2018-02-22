

//-- Ancient Warrior -----------------------------------------------------------

game/hero/warrior
	parent_type = /game/hero
	name="Warrior"
	description={"A warrior from beyond the grave - and from JKD."}
	tier = 4

	level_knight = 1
	level_priest = 1
	level_mage   = 1
	level_rogue  = 1
	icon = 'red_warrior.dmi'
	max_health = 6
	max_aura = 4
	aura_rate = 130
	projectile_type = /game/hero/projectile/gold_axe
	front_protection = TRUE
	//skill1_cost = 1
	skill1_cost = 2
	skill2_cost = 4
	//skill1 = /game/hero/skill/heal
	skill1 = /game/hero/warrior/spew_skill
	skill2 = /game/hero/warrior/barrier_encircle_skill

	red_bone
		name = "Red Bone"
		parent_type = /game/hero/lich/skeleton
		level_knight = 4
		level_priest = 4
		level_mage   = 4
		level_rogue  = 4
		icon = 'red_bone.dmi'
		tombing = FALSE
		max_health = 8
		hero_type = /game/hero/warrior
		New()
			. = ..()
			projectile_type = /game/hero/projectile/gold_axe

	spew_skill
		parent_type = /game/hero/skill
		name = "Fire Spew"
		description = {"Spews Fire."}
		potency = 2
		activate()
			owner.cast_time(30)
			spawn(1/30)
				var skill_dir;
				switch(owner.dir)
					if(EAST)
						skill_dir =  0-48
					if(NORTH)
						skill_dir = 90-48
					if(WEST)
						skill_dir =180-48
					if(SOUTH)
						skill_dir =270-48
				for(var/spew_index = 1 to 16)
					if(!owner) return
					if(!(spew_index%2))
						var/game/map/mover/projectile/stationary_fire/F = new(owner)
						F.persistent = TRUE
						F.layer = owner.layer+1
						F.max_range = 64
						F.vel.x = cos(skill_dir)*3
						F.vel.y = sin(skill_dir)*3
					skill_dir+=8
					sleep(1/30)

	barrier_encircle_skill
		parent_type = /game/hero/skill
		name = "Barrier Encircle"
		activate()
			owner.cast_time(9)
			var/game/hero/warrior/barrier_encircle/B = new(owner)
			B = new(owner)
			B.theta_offset = 120
			B = new(owner)
			B.theta_offset = 240
			var/heal_range = 32
			for(var/game/hero/H in range(COLLISION_RANGE, owner))
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range)
					new /game/hero/warrior/barrier(H)

	barrier_encircle
		parent_type = /game/hero/projectile
		icon = 'projectiles.dmi'
		icon_state = "fire_orb"
		persistent = TRUE
		potency = 0
		width = 0
		height = 0
		x_offset = -8
		y_offset = -8
		var
			angle = 0
			radius = 24
			theta_offset = 0
		impact(){}
		behavior()
			. = ..()
			angle += 15
			if(angle >= 360){ Del()}
			c.x = (owner.c.x+(owner.width /2)) + cos(angle+theta_offset)*radius
			c.y = (owner.c.y+(owner.height/2)) + sin(angle+theta_offset)*radius

	barrier
		parent_type = /game/hero/projectile
		icon = 'large.dmi'
		icon_state = "barrier_fire"
		persistent = TRUE
		impact(){}
		potency = 2
		height = 28
		width  = 28
		max_time = 192
		behavior()
			if(max_time-- <= 0)
				del src
			c.x = (owner.c.x+(owner.width /2))-(width /2)
			c.y = (owner.c.y+(owner.height/2))-(height/2)
			for(var/game/enemy/E in orange(COLLISION_RANGE,src))
				if(E.invulnerable){ continue}
				if(!collision_check(E)){ continue}
				//var/delta_x = abs((P.c.x+(P.width /2)) - (c.x+(width /2)))
				//var/delta_y = abs((P.c.y+(P.height/2)) - (c.y+(height/2)))
				//var/c_range = sqrt((delta_x*delta_x)+(delta_y*delta_y))
				//if(c_range > radius){ continue}
				owner.attack(E, potency)
