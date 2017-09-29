skill {}
game/hero/skill {
	parent_type = /skill
	var game/hero/owner, name, description={""}, potency
	proc {
		activate()
		}
	New(var/game/hero/_owner) {
		. = ..()
		owner = _owner
		}


	heal {
		name = "Heal"
		description={"Heals the player and surrounding allies for ~p health."}
		potency = 1
		activate(){
			if(owner.specialtype=="f0lak" && !owner.ael){ owner.adjust_aura(owner.skill2_cost);return} // if f0lak is not in ghost mode, he can't heal, so replenish his mana
			owner.cast_time(9)
			var/heal_range = 32
			for(var/I = 1 to 4){
				var/game/hero/projectile/healing/H = new(owner)
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				switch(I){
					if(1){ H.vel.x =  3; H.vel.y =  3}
					if(2){ H.vel.x = -3; H.vel.y =  3}
					if(3){ H.vel.x = -3; H.vel.y = -3}
					if(4){ H.vel.x =  3; H.vel.y = -3}
					}
				}
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					H.adjust_health(potency, owner)
					if(H != owner){
						H.invulnerable = max(H.invulnerable, 6)
						}
					}
				}
			}
		}
	protect {
		name = "Protect"
		description={"This skill allows the player and surrounding allies to become invincible for a short period of time."}
		activate(){
			owner.cast_time(9)
			var/heal_range = 32
			for(var/I = 1 to 8){
				var/game/hero/projectile/healing/H = new(owner)
				H.icon = 'items.dmi'
				H.icon_state = "shield"
				H.width = 8
				H.height = 8
				H.max_range = 0
				H.max_time = 10
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				var/angle = (I-1)*(360/8)
				H.vel.x = cos(angle)*4
				H.vel.y = sin(angle)*4
				}
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					H.invulnerable = max(H.invulnerable, 150)
					}
				}
			}
		}
	mana_heal {
		name = "Mana Regenerate"
		//description = {"Regenerates mana of nearby party members."}
		activate(){
			owner.time_out(64)
			owner.icon_state = "meditate"
			var/heal_range = 32
			for(var/I = 1 to 8){
				var/game/hero/projectile/healing/H = new(owner)
				H.icon = 'items.dmi'
				H.icon_state = "bottle"
				H.width = 8
				H.height = 8
				H.max_range = 0
				H.max_time = 10
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				var/angle = (I-1)*(360/8)
				H.vel.x = cos(angle)*4
				H.vel.y = sin(angle)*4
				}
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					if(H != owner){
						H.adjust_aura(1)
						}
					}
				}
			}
		}
	kill_all{
		name = "Kill All"
		description = {"Kill everything."}
		activate() {
			var/first
			for(var/game/enemy/E){
				if(!first){ first = E; continue}
				E.die()
				}
			}
		}

	fire_snake {
		name = "Fire Snake"
		description = {"A long line of fire travels at high speed for under the control of the caster, hurting multiple targets."}
		activate(){
			owner.cast_time(6)
			new /game/hero/projectile/fire_snake(owner)
			}
		}
	heal_cherry {
		name = "Cherry Heal"
		description = {"Heals ~p health of surrounding party members by hurling out cherries in various directions."}
		potency = 1
		activate(){
			owner.icon_state = "cast"
			owner.cast_time(9)
			var/heal_range = 32
			for(var/I = 1 to 8){
				var/game/hero/projectile/healing/H = new(owner)
				H.icon = 'items.dmi'
				H.icon_state = "cherry"
				H.width = 8
				H.height = 8
				H.max_range = 0
				H.max_time = 10
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				var/angle = (I-1)*(360/8)
				H.vel.x = cos(angle)*4
				H.vel.y = sin(angle)*4
				}
			owner.adjust_health(potency, owner)
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					if(H != owner){
						H.adjust_health(potency, owner)
						H.invulnerable = max(H.invulnerable, 6)
						}
					}
				}
			}
		}

	heal_radish {
		name = "Radish Heal"
		activate() {
			owner.icon_state = "cast"
			owner.cast_time(9)
			var/heal_range = 32
			var/potency = 1
			for(var/I = 1 to 8){
				var/game/hero/projectile/healing/H = new(owner)
				H.icon = 'gnome_enemies.dmi'
				H.icon_state = "radish"
				H.width = 8
				H.height = 8
				H.max_range = 0
				H.max_time = 10
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				var/angle = (I-1)*(360/8)
				H.vel.x = cos(angle)*4
				H.vel.y = sin(angle)*4
				}
			owner.adjust_health(potency, owner)
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					if(H != owner){
						H.adjust_health(potency, owner)
						H.invulnerable = max(H.invulnerable, 6)
						}
					}
				}
			}
		}

	flame_arrow {
		name = "Flame Arrow"
		description={"A flaming arrow travels forward, doing 1 point of damage to the first enemy it hits, and leaving behind a persistent stationary flame which does 2 points of damage to any enemy that touches it."}
		activate(){
			new /game/hero/projectile/arrow_flaming(owner)
			}
		}

	triple_arrow {
		name = "Triple Arrow"
		description={"Three arrows fire from the user's bow, doing 1 point of damage to the first enemy they encounter."}
		activate(){
			var non_unique_arrow = /game/hero/projectile/arrow{unique = 0}
			var/game/hero/projectile/arrow/A1 = new non_unique_arrow(owner)
			var/game/hero/projectile/arrow/A2 = new non_unique_arrow(owner)
			var/game/hero/projectile/arrow/A3 = new non_unique_arrow(owner)
			var speed = 1
			switch(owner.dir){
				if(NORTH){
					A1.vel.x = -speed;
					A3.vel.x =  speed;
					A2.vel.y++
					}
				if(SOUTH){
					A1.vel.x =  speed;
					A3.vel.x = -speed;
					A2.vel.y--
					}
				if(EAST){
					A1.vel.y = -speed;
					A3.vel.y =  speed;
					A2.vel.x++
					}
				if(WEST){
					A1.vel.y =  speed;
					A3.vel.y = -speed;
					A2.vel.x--
					}
				}
			}
		}
	proj_wood_sword {
		name = "Wood Sword"
		activate(){ owner.projectile = new /game/hero/projectile/wood_sword(owner)} }
	proj_gold_sword {
		name = "Gold Sword"
		activate(){ owner.projectile = new /game/hero/projectile/gold_sword(owner)} }
	proj_wood_axe {
		name = "Wood Axe"
		activate(){ owner.projectile = new /game/hero/projectile/wood_axe(owner)} }
	proj_gold_axe {
		name = "Gold Axe"
		activate(){ owner.projectile = new /game/hero/projectile/gold_axe(owner)} }
	proj_lance {
		name = "Lance"
		activate(){ owner.projectile = new /game/hero/projectile/lance(owner.)} }
	proj_axe {
		name = "Axe"
		activate(){ owner.projectile = new /game/hero/projectile/axe(owner)} }
	proj_ball {
		name = "Ball"
		activate(){ owner.projectile = new /game/hero/projectile/ball(owner)} }
	proj_arrow {
		name = "Arrow"
		activate(){ owner.projectile = new /game/hero/projectile/arrow(owner)} }
	bomb_arrow {
		name = "Bomb Arrow"
		description = {"An explosive arrow travels forward, exploding on contact and doing ~p points of damage to any enemy nearby."}
		potency = 2
		activate(){
			new /game/hero/projectile/arrow_bomb(owner)
			}
		}
	send_projectile_type {
		name = "Send Projectile Type"
		activate(){ owner.shoot()}
		}
	proj_note {
		name = "Projectile Note"
		activate(){
			owner.cast_time(9)
			var/game/hero/projectile/note/P
			var/angle = 0
			switch(owner.dir){
				if(EAST ){ angle = 0  }
				if(NORTH){ angle = 90 }
				if(WEST ){ angle = 180}
				if(SOUTH){ angle = 270}
				}
			P = new /game/hero/projectile/note{single=0}(owner)
			P.single = FALSE
			P.vel.x = cos(angle-30)*P.speed
			P.vel.y = sin(angle-30)*P.speed
			P = new /game/hero/projectile/note{single=0}(owner)
			P.single = FALSE
			P.vel.x = cos(angle)*P.speed
			P.vel.y = sin(angle)*P.speed
			P = new /game/hero/projectile/note{single=0}(owner)
			P.single = FALSE
			P.vel.x = cos(angle+30)*P.speed
			P.vel.y = sin(angle+30)*P.speed
			}
		}
	push_fist {
		name = "Punch"
		activate(){
			owner.projectile = new /game/hero/projectile/pushing_fist(owner)
			}
		}
	bomb {
		name = "Bomb"
		description = {"Drops a bomb which explodes shortly afterward, dealing ~p points of damage to any enemy or player nearby. Explosion does extra damage to snaking enemies."}
		potency = 2
		activate(){
			if(owner.disappeared){ return}
			new /game/hero/projectile/bomb(owner)
			}
		}
	ninja_star {
		name = "Ninja Star"
		description = {"A powerful throwing star travels forward a short distance, doing ~p points of damage to the first enemy it hits."}
		potency = 2
		activate(){
			if(owner.disappeared){ return}
			new /game/hero/projectile/star(owner)
			}
		}
	rebel_star {
		name = "Rebel Star"
		activate(){
			owner.cast_time(9)
			for(var/I = 1 to 4){
				var/game/hero/projectile/light/H = new(owner)
				H.potency = 0
				H.icon_state = "rebel_star"
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				switch(I){
					if(1){ H.vel.x =  3; H.vel.y =  3}
					if(2){ H.vel.x = -3; H.vel.y =  3}
					if(3){ H.vel.x = -3; H.vel.y = -3}
					if(4){ H.vel.x =  3; H.vel.y = -3}
					}
				}
			for(var/game/hero/H){
				if(H.type == /game/hero/lich/skeleton){
					game.add_hero(H.player, /game/hero/warrior/red_bone)
					continue
				}
				if(!(H.type in list(/game/hero/_blank, /game/hero/_member, /game/hero/_hazordhu, /game/hero/_regressia))){
					continue
					}
				if( \
					abs( (owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2))) < 64 \
					&& \
					abs( (owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2))) < 64 \
					){
					var/hero_type = pick(
						/game/hero/rebel/fighter,
						/game/hero/rebel/healer,
						/game/hero/rebel/magician,
						/game/hero/rebel/anarchist,
						)
					game.add_hero(H.player, hero_type)
					}
				}
			}
		}
	light {
		name = "Light Magic"
		description = {"Does ~p points of damage to all undead enemies surrounding the caster."}
		potency = 2
		activate(){
			owner.cast_time(9)
			for(var/I = 1 to 4){
				var/game/hero/projectile/light/H = new(owner)
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				switch(I){
					if(1){ H.vel.x =  3; H.vel.y =  3}
					if(2){ H.vel.x = -3; H.vel.y =  3}
					if(3){ H.vel.x = -3; H.vel.y = -3}
					if(4){ H.vel.x =  3; H.vel.y = -3}
					}
				}
			}
		}
	light2 {
		name = "Light Magic Level Two"
		description = {"Does ~p points of damage to all undead or demon enemies surrounding the caster."}
		potency = 3
		activate(){
			owner.cast_time(9)
			for(var/I = 1 to 4){
				var/game/hero/projectile/light_2/H = new(owner)
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				switch(I){
					if(1){ H.vel.x =  3; H.vel.y =  3}
					if(2){ H.vel.x = -3; H.vel.y =  3}
					if(3){ H.vel.x = -3; H.vel.y = -3}
					if(4){ H.vel.x =  3; H.vel.y = -3}
					}
				}
			}
		}
	life{
		name = "Life"
		description = {"Revives any tomb'd player close to the caster. Can also return a skeleton character to their original class."}
		activate(){
			owner.cast_time(9)
			for(var/I = 1 to 4){
				var/game/hero/projectile/light/H = new(owner)
				H.icon_state = "life"
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				switch(I){
					if(1){ H.vel.x =  3; H.vel.y =  3}
					if(2){ H.vel.x = -3; H.vel.y =  3}
					if(3){ H.vel.x = -3; H.vel.y = -3}
					if(4){ H.vel.x =  3; H.vel.y = -3}
					}
				}
			for(var/game/hero/tomb/T){
				if( \
					abs( (owner.c.x+(owner.width /2)) - (T.c.x+(T.width /2))) < 32 \
					&& \
					abs( (owner.c.y+(owner.height/2)) - (T.c.y+(T.height/2))) < 32 \
					){
					T.restore()
					}
				}
			for(var/game/hero/lich/skeleton/S){
				if( \
					abs( (owner.c.x+(owner.width /2)) - (S.c.x+(S.width /2))) < 32 \
					&& \
					abs( (owner.c.y+(owner.height/2)) - (S.c.y+(S.height/2))) < 32 \
					){
					S.restore()
					}
				}
			}
		}
	lich_life {
		name = "Life"
		description = {"Revives nearby tomb'd players as skeleton warriors."}
		activate(){
			owner.cast_time(9)
			for(var/I = 1 to 4){
				var/game/hero/projectile/light/H = new(owner)
				H.potency = 3
				H.icon_state = "life"
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				switch(I){
					if(1){ H.vel.x =  3; H.vel.y =  3}
					if(2){ H.vel.x = -3; H.vel.y =  3}
					if(3){ H.vel.x = -3; H.vel.y = -3}
					if(4){ H.vel.x =  3; H.vel.y = -3}
					}
				}
			for(var/game/hero/tomb/T){
				if( \
					abs( (owner.c.x+(owner.width /2)) - (T.c.x+(T.width /2))) < 32 \
					&& \
					abs( (owner.c.y+(owner.height/2)) - (T.c.y+(T.height/2))) < 32 \
					){
					var/hero_type = T.hero_type
					var/game/hero/lich/skeleton/H2 = T.restore(/game/hero/lich/skeleton)
					H2.adjust_health(H2.max_health)
					H2.hero_type = hero_type
					}
				}
			}
		}
	magic1 {
		name = "Fireball"
		description = {"Travels forward and does ~p point of damage to the first enemy it hits."}
		potency = 1
		activate(){
			owner.cast_time(6)
			new /game/hero/projectile/magic_1(owner)
			}
		}
	magic2 {
		name = "Fire Blast"
		description = {"Travels forward and does ~p points of damage to the first enemy it hits."}
		potency = 2
		activate(){
			owner.cast_time(6)
			new /game/hero/projectile/magic_2(owner)
			}
		}
	radish1 {
		name = "Radish"
		activate(){
			owner.cast_time(9)
			new /game/hero/gnome/radish_1(owner)
			}
		}
	seeker {
		name = "Seeker"
		description = {"Travels forward and seeks nearby enemies, doing ~p points of damage to the first enemy it hits."}
		potency = 2
		activate(){
			owner.cast_time(6)
			new /game/hero/projectile/seeker(owner)
			}
		}
	magic_sword {
		name = "Magic Sword"
		description = {"Travels forward and does ~p points of damage to the first enemy it hits."}
		potency = 2
		activate() {
			owner.cast_time(6)
			new /game/hero/projectile/magic_sword(owner)
			}
		}
	invulnerable {
		name = "Invulnerability"
		description = {"The caster becomes invulnerable for a short period of time."}
		activate(){
			owner.invulnerable = max(owner.invulnerable, 200)
			owner.cast_time(6)
			}
		}
	heal_orb {
		name = "Healing Orb"
		description = {"A controllable orb of healing can target 1 player, healing ~p points of damage."}
		potency = 2
		activate(){
			owner.intelligence = new /game/hero/projectile/healing_orb(owner)
			}
		}
	aura_orb {
		name = "Mana Orb"
		description = {"A controllable orb can target 1 player, restoring ~p points of Aura."}
		potency = 2
		activate(){
			owner.intelligence = new /game/hero/projectile/aura_orb(owner)
			}
		}
	fire_orb {
		name = "Fire Orb"
		description = {"A controllable orb of fire leaves behind a persistent stationary fireball, doing ~p points of damage to any enemy that touches it."}
		potency = 2
		activate(){
			owner.intelligence = new /game/hero/projectile/fire_orb(owner)
			}
		}
	note_orb {
		name = "Note Orb"
		activate(){
			new /game/hero/projectile/note_orb(owner)
			}
		}
	barrier_orb {
		name = "Barrier Orb"
		activate(){
			owner.intelligence = new /game/hero/projectile/barrier_orb(owner)
			}
		}
	fire_large {
		name = "Large Fire"
		description = {"Fire Blasts travel a short distance out from the caster in 16 directions."}
		activate(){
			owner.cast_time(28)
			for(var/I = 1 to 16){
				var /game/hero/projectile/fire_persistent/F = new(owner)
				F.icon_state = "fire_large"
				F.width = 16
				F.height = 16
				F.c.x = owner.c.x+((owner.width  - F.width )/2)
				F.c.y = owner.c.y+((owner.height - F.height)/2)
				var/angle = (I-1)*(360/16)
				F.vel.x =  cos(angle)*4
				F.vel.y =  sin(angle)*4
				switch(angle){
					if(    0 to   22.5){ F.dir = EAST     }
					if( 22.5 to   67.5){ F.dir = NORTHEAST}
					if( 67.5 to  112.5){ F.dir = NORTH    }
					if(112.5 to  157.5){ F.dir = NORTHWEST}
					if(157.5 to  202.5){ F.dir = WEST     }
					if(202.5 to  247.5){ F.dir = SOUTHWEST}
					if(247.5 to  292.5){ F.dir = SOUTH    }
					if(292.5 to  337.5){ F.dir = SOUTHEAST}
					if(337.5 to  360.0){ F.dir = EAST     }
					}
				}
			}
		}
	controlled_sword {
		name = "Controlled Sword"
		description = {"Travels forward under the control of the caster, doing ~p points of damage to the first enemy it hits, and exploding into four Magic Swords that travel outward for a short distance."}
		potency = 2
		activate(){
			owner.cast_time(6)
			new /game/hero/projectile/controlled_sword(owner)
			}
		}
	summon_skeleton {
		name = "Summon Skeleton"
		description = {"Summons a skeleton to fight the enemy."}
		activate(){
			var/game/hero/summon/skeleton/skeleton = new(owner)
			skeleton.c.x = owner.c.x
			skeleton.c.y = owner.c.y
			skeleton.redraw()
			}
		}
	summon_fire {
		name = "Summon Fire"
		description = {"Summons a weak Fire Elemental which wanders and shoots Fire Blasts and nearby enemies."}
		activate(){
			if(game.stage == STAGE_WIN){ return}
			var/game/hero/summon/fire/fire = new(owner)
			fire.c.x = owner.c.x
			fire.c.y = owner.c.y
			fire.redraw()
			}
		}
	summon_wind {
		name = "Summon Wind"
		description = {"Summons an Air Elemental which stays close to the caster, and pushes enemies away with a strong wind."}
		activate(){
			if(game.stage == STAGE_WIN){ return}
			var/game/hero/summon/wind/wind = new(owner)
			wind.c.x = owner.c.x
			wind.c.y = owner.c.y
			wind.redraw()
			}
		}
	summon_wind_golem {
		name = "Summon Wind Golem"
		description = {"Summons a strong Golem which seeks out and attacks enemies."}
		activate(){
			if(game.stage == STAGE_WIN){ return}
			var/game/hero/summon/golem/wind = new(owner)
			wind.c.x = owner.c.x
			wind.c.y = owner.c.y
			wind.redraw()
			}
		}
	jim_and_the_pirates {
		name = "Jim and the Pirates!"
		description = {"A show worth remembering."}
		activate(){
			owner.overlays.Add(owner.arr_overlay)
			owner.invulnerable = max(owner.invulnerable, INVULNERABLE_TIME)
			spawn(25){
				owner.overlays.Remove(owner.arr_overlay)
				}
			var/list/band_members = list(
				/game/hero/bard,
				/game/hero/minstrel,
				/game/hero/gypsy,
				/game/hero/pirate,
				)
			for(var/game/hero/H in game.heros){
				if(H.type in band_members){
					band_members.Remove(H.type)
					}
				}
			if(!band_members.len){
				world << "<b>Put your hands together for 'Jim and the Pirates'!</b>"
				game.add_hero(owner.player, /game/hero/pirate/bard)
				}
			}
		}
	pirate_mode {
		name = "Pirate Mode"
		activate(){
			owner.overlays.Add(owner.arr_overlay)
			owner.invulnerable = INVULNERABLE_TIME
			spawn(25){
				owner.overlays.Remove(owner.arr_overlay)
				}
			}
		}
	ninja_mode {
		name = "Ninja Mode"
		description = {"Enter into ninja mode. Temporarily invisible."}
		activate(){
			if(owner.disappeared){ return}
			owner.invincible = TRUE
			owner.disappeared = 64
			owner.invisibility = 1
			owner.trapable = FALSE
			}
		}
	rogue_mode {
		name = "Rogue Mode"
		description = {"Enter into steal mode. Temporarily invulnerable."}
		activate(){
			owner.invulnerable = INVULNERABLE_TIME
			}
		}
	barrier_circle {
		name = "Barrier Circle"
		description = {"All heros around, and including, the caster are surrounded by a protective barrier. The barrier stuns enemies, doing ~p point of damage, and destroys projectiles, but disappears after colliding with an enemy or projectile twice."}
		potency = 1
		activate(){
			owner.cast_time(9)
			var/game/hero/projectile/barrier_encircle/B = new(owner)
			B = new(owner)
			B.theta_offset = 120
			B = new(owner)
			B.theta_offset = 240
			var/heal_range = 32
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					new /game/hero/projectile/barrier(H)
					}
				}
			}
		}
	fire_dance {
		name = "Fire Dance"
		activate(){
			owner.cast_time(120)
			var/angle = rand(0, 72)
			var/game/hero/projectile/fire_dance/F = new(owner)
			F.angle = angle
			F = new(owner)
			F.angle = angle + 72
			F = new(owner)
			F.angle = angle + 144
			F = new(owner)
			F.angle = angle + 216
			F = new(owner)
			F.angle = angle + 288
			}
		}
	freeze_dance {
		name = "Freeze Dance"
		activate(){
			owner.cast_time(120)
			var/angle = rand(0, 72)
			var/game/hero/projectile/freeze_dance/F = new(owner)
			F.angle = angle
			F = new(owner)
			F.angle = angle + 51//72
			F = new(owner)
			F.angle = angle + 102//144
			F = new(owner)
			F.angle = angle + 153//216
			F = new(owner)
			F.angle = angle + 204//288
			F = new(owner)
			F.angle = angle + 255//288
			F = new(owner)
			F.angle = angle + 306//288
			}
		}
	both_dance {
		name = "Dance"
		activate(){
			owner.cast_time(120)
			var/angle = rand(0, 72)
			var/game/hero/projectile/freeze_dance/Fr = new(owner)
			var/game/hero/projectile/fire_dance/Fi = new(owner)
			Fr.angle = angle + 45
			Fi.angle = angle + 90
			Fr = new(owner)
			Fi = new(owner)
			Fr.angle = angle + 135
			Fi.angle = angle + 180
			Fr = new(owner)
			Fi = new(owner)
			Fr.angle = angle + 225
			Fi.angle = angle + 270
			Fr = new(owner)
			Fi = new(owner)
			Fr.angle = angle + 315
			Fi.angle = angle + 360
			}
		}
	slow {
		name = "Slow"
		description = {"Stops all enemies for a short period of time."}
		activate(){
			owner.cast_time(9)
			for(var/game/enemy/E in game.map.enemies){
				E.intelligence = new /game/map/mover/intelligence/slow(128)
				}
			}
		}

	bat_change {
		name = "Bat Mode"
		activate(){
			if(owner.bat){
				owner.height = initial(owner.height)
				owner.projectile_type = initial(owner.projectile_type)
				owner.icon_state = null
				owner.bat = FALSE
				owner.movement = MOVEMENT_LAND
				owner.speed = initial(owner.speed)
				}
			else{
				if(owner.aura){
					owner.height = 8
					owner.projectile_type = /game/hero/projectile/magic_2
					owner.icon_state = "bat"
					owner.bat = TRUE
					owner.movement = MOVEMENT_ALL
					owner.speed = 2
					}
				}
			}
		}

	summon_genie {
		name = "Summon Genie"
		description = {"Summons a powerful genie, who casts invulnerability on the party, heals wounded players, and shoots fire blasts at the enemy. Can only be used three times."}
		activate(){
			if(game.stage == STAGE_WIN){ return}
			if(owner.genie){ return}
			owner.genie = new(owner)
			owner.genie.c.x = owner.c.x
			owner.genie.c.y = owner.c.y
			owner.genie.redraw()
			}
		}

// SUBSCRIBER SKILLS
// MAY NEED MODIFICATION TO RELATE BACK TO GENERAL CHARACTERS

// cauti0n skills
	dash {
		name = "Dash"
		activate(){
			if(owner.endwave) { return}
			if(owner.dash){
				owner.height = initial(owner.width)
				owner.projectile_type = initial(owner.projectile_type)
				owner.icon = initial(owner.icon)
				owner.icon_state = initial(owner.icon_state)
				owner.dash = FALSE
				owner.reverseDamage = 0
				owner.movement = initial(owner.movement)
				owner.speed = initial(owner.speed)
				}
			else{
				if(owner.aura){
					owner.height = 8
					owner.icon_state="dash"
					owner.dash = TRUE
					owner.reverseDamage = 5
					owner.movement = MOVEMENT_LAND
					for(var/angle in list(0, 60, 120, 180, 240, 300)){
						var/game/hero/projectile/wind/wind = new(owner)
						wind.vel.x = cos(angle)*4
						wind.vel.y = sin(angle)*4
						wind.max_range = 24
						}
					}
				}
			}
		}









// FROM summons


	fireball {
		name = "Fireball"
		activate(){
			var/game/enemy/E = locate() in orange(COLLISION_RANGE, owner)
			var/skill_dir = arctan(E.c.x-owner.c.x, E.c.y-owner.c.y)
			var/game/hero/projectile/magic_2/fire = new(owner)
			fire.vel.x = cos(skill_dir)*5
			fire.vel.y = sin(skill_dir)*5
			}
		}

	cloud_blow {
		name = "Cloud Blow"
		activate(){
			if(owner.aura < 5 && !owner.projectiles.len){ return}
			owner.icon_state = "cloud_blow"
			owner.time_out(6)
			var/game/enemy/E = locate() in orange(COLLISION_RANGE, owner)
			owner.dir = get_dir(owner, E)
			var/skill_dir = arctan(E.c.x-owner.c.x, E.c.y-owner.c.y)
			skill_dir += rand(-30, 30)
			var/game/hero/projectile/wind/wind = new(owner)
			wind.vel.x = cos(skill_dir)*5
			wind.vel.y = sin(skill_dir)*5
			}
		}

	golem_fist {
		name = "Golem Fist"
		activate(){
			new /game/hero/summon/golem/fist(owner)
			}
		}

	send_projectile_type {
		name = "Send Projectile"
		activate(){
			new owner.projectile_type(owner)
			}
		}

	genie_fire {
		name = "Genie Fire"
		activate(){
			var/game/enemy/E = locate() in orange(COLLISION_RANGE, owner)
			if(!E){ return}
			owner.time_out(3)
			if(abs(E.c.x - owner.c.x) >= abs(E.c.y - owner.c.y)){
				if(E.c.x >= owner.c.x){ owner.dir = EAST }
				else{             		owner.dir = WEST }
				}
			else{
				if(E.c.y >= owner.c.y){ owner.dir = NORTH}
				else{             		owner.dir = SOUTH}
				}
			var/skill_dir = arctan(E.c.x-owner.c.x, E.c.y-owner.c.y)
			var/game/hero/projectile/magic_2/fire = new(owner)
			fire.vel.x = cos(skill_dir)*5
			fire.vel.y = sin(skill_dir)*5
			}
		}

	genie_protect {
		name = "Genie Protect"
		activate() {
			owner.time_out(1)
			for(var/I = 1 to 8){
				var/game/hero/projectile/healing/H = new(owner)
				H.icon = 'items.dmi'
				H.icon_state = "shield"
				H.width = 8
				H.height = 8
				H.max_range = 0
				H.max_time = 10
				H.c.x = owner.c.x + (owner.width -H.width )/2
				H.c.y = owner.c.y + (owner.height-H.height)/2
				var/angle = (I-1)*(360/8)
				H.vel.x = cos(angle)*4
				H.vel.y = sin(angle)*4
				}
			for(var/game/hero/H in game.heros){
				H.invulnerable = max(H.invulnerable, 96)
				}
			}
		}


// CUSTOM SKILLS

// Joram
	joram_needle {
		name = "Needle"
		activate(){
			owner.cast_time(9)
			owner.icon_state = "attack"
			new /game/hero/custom/joram/needle(owner)
			}
		}
	joram_darter {
		name = "Darter"
		activate(){
			owner.cast_time(9)
			owner.icon_state = "attack"
			owner.intelligence = new /game/hero/custom/joram/darter()
			}
		}

	joram_chakram {
		name = "Chakram"
		activate(){
			owner.cast_time(9)
			owner.icon_state = "attack"
			new /game/hero/custom/joram/chakram(owner)
			}
		}

// D5
	falco_wave {
		name = "Falco Wave"
		activate() {
			if(owner.falcon){
				owner.falcon.callback()
				owner.cast_time(9)
				return
				}
			owner.cast_time(9)
			owner.falcon = new(owner)
			if(!owner.falcon_wave){
				owner.falcon_wave = game.map.wave
				}
			else{
				var/d_wave = game.map.wave - owner.falcon_wave
				if(d_wave >= 9){
					owner.falcon.size = 3
					owner.falcon.max_health = 8
					owner.falcon.icon_state = "falcon_[owner.falcon.size]"
					}
				else if(d_wave >= 4){
					owner.falcon.size = 2
					owner.falcon.max_health = 6
					owner.falcon.icon_state = "falcon_[owner.falcon.size]"
					}
				}
			}
		}

	d5target {
		name = "Target"
		activate(){
			if(!owner.falcon){ return}
			owner.cast_time(9)
			new /game/hero/custom/d4rk354b3r/target(owner)
			}
		}



	d5bolt {
		name = "Bolt"
		activate(){
			owner.cast_time(10)
			new /game/hero/subscriber/d4rk354b3r/bolt(owner, 0)
			new /game/hero/subscriber/d4rk354b3r/bolt(owner, 1)
			new /game/hero/subscriber/d4rk354b3r/bolt(owner, 2)
			}
		}
	d5barrier_encircle{
		name = "Barrier Encircle"
		activate(){
			owner.cast_time(9)
			var/game/hero/subscriber/d4rk354b3r/barrier_encircle/B = new(owner)
			B = new(owner)
			B.theta_offset = 120
			B = new(owner)
			B.theta_offset = 240
			var/heal_range = 32
			for(var/game/hero/H in range(COLLISION_RANGE, owner)){
				var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
				var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
				if(min(d_x, d_y) <= heal_range){
					new /game/hero/subscriber/d4rk354b3r/barrier(H)
					}
				}
			}
		}
	d5combat_potential {
		name = "Combat Potential"
		activate(){
			owner.cast_time(9)
			var/list/targets = list()
			var/max_dist = 48
			for(var/game/map/mover/combatant/potential in orange(COLLISION_RANGE, owner)){
				if(targets.len >= 7){ break}
				var/d_x = abs((owner.c.x+(owner.width /2)) - (potential.c.x+(potential.width /2)))-potential.width /2
				var/d_y = abs((owner.c.y+(owner.height/2)) - (potential.c.y+(potential.height/2)))-potential.height/2
				var/dist = sqrt(d_x*d_x + d_y*d_y)
				if(dist < max_dist){
					targets.Add(potential)
					}
				}
			for(var/game/map/mover/combatant/target in targets){
				new /game/hero/subscriber/d4rk354b3r/chain(owner, target)
				}
			}
		}

// DOONEY1

	boulder_push{
		name = "Boulder Push"
		activate(){
			owner.cast_time(9)
			new /game/hero/custom/dooney1/earth(owner)
			//boulder push
			}
		}

	earth_wall {
		name = "Earth Wall"
		activate(){
			owner.cast_time(9)
			new /game/hero/custom/dooney1/wall(owner)
			//Earth wall
			}
		}
	earth_armor {
		name = "Earth Armor"
		activate(){
			if(owner.armor){ return}
			owner.cast_time(16)
			new /game/hero/custom/dooney1/barrier(owner)
			owner.armor_on()
			//Earth armor
			}
		}


// CALUS CORPS

	ccheal{
		name = "Heal"
		activate(){
			if(owner.aura >= 1){
				owner.cast_time(9)
				var/heal_range = 32
				var/potency = 1
				for(var/I = 1 to 4){
					var/game/hero/projectile/healing/H = new(owner)
					H.c.x = owner.c.x + (owner.width -H.width )/2
					H.c.y = owner.c.y + (owner.height-H.height)/2
					switch(I){
						if(1){ H.vel.x =  3; H.vel.y =  3}
						if(2){ H.vel.x = -3; H.vel.y =  3}
						if(3){ H.vel.x = -3; H.vel.y = -3}
						if(4){ H.vel.x =  3; H.vel.y = -3}
						}
					}
				for(var/game/hero/H in range(COLLISION_RANGE, owner)){
					var/d_x = abs((owner.c.x+(owner.width /2)) - (H.c.x+(H.width /2)))
					var/d_y = abs((owner.c.y+(owner.height/2)) - (H.c.y+(H.height/2)))
					if(min(d_x, d_y) <= heal_range){
						H.adjust_health(potency, owner)
						if(H != owner){
							H.invulnerable = max(H.invulnerable, 6)
							}
						}
					}
				}
			}
		}

	explode_gift {
		name = "Exploding Gift"
		activate(){
			owner.overlays.Add(owner.arr_overlay)
			new /game/hero/subscriber/caluscorps/exploding_gift(owner)
			spawn(10){
				owner.overlays.Remove(owner.arr_overlay)
				}
			}
		}
	summon_elf {
		name = "Summon Santa's Helper"
		activate(){
			var/game/hero/subscriber/caluscorps/elf/elf = new(owner)
			elf.c.x = owner.c.x
			elf.c.y = owner.c.y
			elf.redraw()
			}
		}
	ccgift {
		name = "Gift"
		activate(){
			new /game/hero/subscriber/caluscorps/gift(owner)
			}
		}


// f0lak

	ghost_mode {
		name = "Ghost Mode"
		activate(){
			if(owner.ael){
				owner.height = initial(owner.width)
				owner.projectile_type = initial(owner.projectile_type)
				owner.icon = initial(owner.icon)
				owner.ael = FALSE
				owner.movement = initial(owner.movement)
				owner.speed = initial(owner.speed)
				}
			else{
				if(owner.aura){
					owner.height = 8
					owner.projectile_type = /game/hero/projectile/magic_2
					owner.icon = 'f0lak.dmi'
					owner.ael = TRUE
					owner.movement = MOVEMENT_ALL
					owner.speed = 2
					}
				}
			}
		}

	f0transform {
		name = "Transform"
		activate(){
			if(!owner.ael){ return}
			owner.cast_time(9)
			new /game/hero/subscriber/f0lak/transformer(owner)
			}
		}



// FUGSNARF


	fug_pounder {
		name = "Pounder"
		activate(){
			owner.intelligence = new /game/hero/subscriber/fugsnarf/pounder()
			}
		}

	fug_charger {
		name = "Charger"
		activate(){
			owner.intelligence = new /game/hero/subscriber/fugsnarf/charger()
			}
		}

// shared with jamckell
	jump_attack {
		name = "Jump Attack"
		activate(){
			// INCLUDE ANY SPECIAL VARIABLES HERE.
			if(owner.dash){ return}
			if(owner.javelin){ return}
			if(owner.endwave){ return}
			var newpath = text2path("/game/hero/subscriber/[owner.player.ckey]/jump_shadow")
			if(!newpath) { return}
			new newpath(owner)
			}
		}

// jamckell skills

	javelin {
		name = "Javelin"
		activate(){
			if(!owner.javelin){ return}
			var/game/hero/subscriber/jamckell/javelin/J1 = owner.javelin
			if(istype(J1)){ del J1}
			owner.javelin = null
			}
		}

	javelin_spin {
		name = "Javelin Spin"
		activate(){
			if(owner.javelin){ return}
			owner.projectile = new /game/hero/subscriber/jamckell/jav_spin(owner)
			}
		}
// SONDER

	sonder_grapple {
		name = "Grapple"
		activate(){	owner.projectile = new /game/hero/subscriber/sonder/grapple(owner)} }


// WILLIFERD

	willi_cast {
		name = "Cast"
		activate(){
			var/game/hero/subscriber/williferd/small/S = locate() in owner.projectiles
			if(!S){
				S = new(owner)
				S.walking = TRUE
				owner.icon_state = "cast"
				owner.cast_time(6)
				return
				}
			var/game/hero/subscriber/williferd/tiny/T = locate() in owner.projectiles
			if(!T){
				T = new(owner)
				T.walking = TRUE
				owner.icon_state = "cast"
				owner.cast_time(6)
				}
			}
		}
	willi_leaf {
		name = "Leaf"
		activate(){
			new /game/hero/subscriber/williferd/leaf(owner)
			new /game/hero/subscriber/williferd/leaf(owner)
			new /game/hero/subscriber/williferd/leaf(owner)
			}
		}


// DRACULA_BAT

	drac_bat {
		name = "Bat Mode"
		activate(){
			if(owner.bat){
				owner.height = initial(owner.width)
				owner.projectile_type = initial(owner.projectile_type)
				owner.icon_state = null
				owner.bat = FALSE
				owner.movement = MOVEMENT_LAND
				owner.speed = initial(owner.speed)
				}
			else{
				if(owner.aura){
					owner.height = 8
					owner.projectile_type = /game/hero/projectile/magic_2
					owner.icon_state = "bat"
					owner.bat = TRUE
					owner.movement = MOVEMENT_LAND | MOVEMENT_WATER | MOVEMENT_WALL
					owner.speed = 2
					}
				}
			}
		}


	}