

//------------------------------------------------------------------------------

client
	proc
		show_class(class)
			var/path = text2path("/game/hero/[class]")

			// Block any invalid paths
			if(!path || ispath(path, /game/hero/projectile) || ispath(path, /game/hero/skill) \
			         || ispath(path, /game/hero/summon))
				return

			// Create the class to pull its data
			var/game/hero/H = new path(null)

			src << browse(H.to_html(), "window=class_description;display=1;size=500x500;border=1;can_close=1;can_resize=1;can_minimize=1;titlebar=1")

			del(H)

game/hero
	proc
		output_class_link(ref=world, client/c)
			if(!ref) return
			var/player_name = (c && c.key) || (src.player && src.player.key)
			ref << {"<span class="class_change">\icon[src] [html_encode(player_name)] is now playing as the [to_link()].</span>"}

		to_link(innerHtml=null)
			if(innerHtml == null)
				innerHtml = {"<span style=\"text-transform: capitalize\">[src.name]</span>"}

			// Check if type is actually a playable class. If not, just return text
			if(!projectile_type && !skill1 && !skill2 && !skill3)
				return innerHtml

			var/shortType = copytext("[src.type]", length("/game/hero/")+1)

			return {"<a href="?action=class_info;class=[shortType]">[innerHtml]</a>"}

		to_html(include_header=TRUE)
			// Display primary stats
			var/html = {"
				<table class="stats" style="margin: 12px;">
					<tr>
						<td class="stat_name">
							<span style="text-decoration:underline">
								<img class="class_img" src="\ref[src.icon]" dir="WEST" />
								<big>[name]</big>
							</span>
						</td>
						<td class="stat_tier">Tier [tier]</td>
					</tr>
					<tr>
						<td class="stat_level"><b>Knight Level</b>: [level_knight]</td>
						<td class="stat"><b>Body</b>: [max_health]</td>
					</tr>
					<tr>
						<td class="stat_level"><b>Priest Level</b>: [level_priest]</td>
						<td class="stat"><b>Aura</b>: [max_aura>0 ? max_aura : "N/A"]</td>
					</tr>
					<tr>
						<td class="stat_level"><b>Mage Level</b>: [level_mage]</td>
						<td class="stat"><b>Aura Rate</b>: [aura_rate>=0 ? aura_rate : "N/A"]</td>
					</tr>
					<tr>
						<td class="stat_level"><b>Rogue Level</b>: [level_rogue]</td>
						<td class="stat"><b>Speed</b>: [speed]</td>
					</tr>
			"}

			// Display main attack
			if(projectile_type && ispath(projectile_type, /game/hero/projectile))
				var/game/hero/projectile/proj = new projectile_type(src)
				html += proj.to_html()
				del(proj)

			// Display skills
			var/list/skills = list(src.skill1=src.skill1_cost, src.skill2=src.skill2_cost, src.skill3=src.skill3_cost)
			for(var/i = 1 to skills.len)
				var/skillPath = skills[i]
				var/skillCost = skills[skillPath]
				if(skillPath && ispath(skillPath, /game/hero/skill))
					var/game/hero/skill/skill = new skillPath(src)
					html += skill.to_html("Skill [i]", skillCost)
					del(skill)

			// Display description
			if(description)
				html += {"
					<tr>
						<td colspan="2">
							[description]
						</td>
					</tr>
				"}

			// Close table
			html += {"
					<tr><td class="breaker">&nbsp;</td></tr>
				</table>
			"}

			// Include HTML and style definitions if requested
			if(include_header)
				html = "<html><title>Class Description</title>[hero_html_script]<body>[html]</body></html>"

			return html

game/hero/skill
	proc
		to_html(position="Skill 1", cost=1)
			// Replace "~p" in description with potency value
			var/pos = findtext(description, "~p")
			var/description_fixed = description
			if(pos)
				description_fixed = "[copytext(description,1,pos)][potency][copytext(description,(pos+2))]"
			return {"
					<tr>
						<td class="stat_skill" colspan="2">
							<b>[position]</b>: [name], Cost: [cost]
							<br />
							<span>[description_fixed]</span>
						</td>
					</tr>
			"}

game/hero/projectile
	proc
		to_html()
			// Replace "~p" in description with potency value
			var/pos = findtext(description, "~p")
			var/description_fixed = description
			if(pos)
				description_fixed = "[copytext(description,1,pos)][potency][copytext(description,(pos+2))]"
			return {"
					<tr>
						<td class="stat_skill" colspan="2">
							<b>Main Attack</b>: <span style="text-transform:capitalize">[name]</span>
							 [description_fixed]
						</td>
					</tr>
			"}


//------------------------------------------------------------------------------

var/global/hero_html_script = {"
<style type="text/css">

/* == Global Style =========================================== */
body{
	background-color: #000;
	color: #fff;
	font-family: georgia, serif;
	}
a:link, a:visited, a:active{
	color: #fc0;
	font-weight: bold;
	text-decoration: none;
	}
a:hover{
	text-decoration: underline;
	}
a img{
	border-width: 0px;
	}
img{
	display: inline;
	-ms-interpolation-mode: nearest-neighbor;
	}
p{
	text-align: justify;
	}
/*h1, h2{
	text-align: center;
	}*/
h1,h2,h3,h4,h5,h6{
	font-family: georgia, serif;
	color: #88f;
	}
hr{
	border: 1px solid #444;
	color: #444;
	margin-top: 1em;
	}
em{
	color: #fc9;
	font-style: normal;
	}
a.top{
	margin-left: 2em;
	}
a.top:before{
	content: "--";
	}
#intro{
	font-style: italic;
	}
#intro:before{
	content: open-quote;
	color: #c96;
	font-size: large;
	}
#intro:after{
	content:close-quote;
	color: #c96;
	font-size: large;
	}
blockquote.review{
	width: 30em;
	}
span.review{
	font-style: italic;
	}
a.review:before{
	content: "~~";
	}


/* == Classes Styles =============================================*/

img.class_img{
	display: inline;
	width:32px;
	height:32px;
	padding: 4px;
	}
.item_name{
	text-transform: uppercase;
	color: #eef;
	font-family: verdana, sans-serif;
	font-weight: bold;
	}
table.stats{
	}
table.stats td{
	padding: 4px 1em;
	color: #fff;
	}
table.stats b{
	/*width: 4em;*/
	color: #fff;
	}
td.stat_name, td.stat_level, td.stat_type, td.stat_tier{
	background-color: #336;
	}
td.stat, td.stat_skill{
	background-color: #333;
	}
td.breaker{
	background-color: #000;
	height: 1em;
	}
</style>
"}