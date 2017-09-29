client
	var
		score = 0
		waves = 0 // Number of consecutive waves

		high_score = 0 // Highest score reached
		high_wave = 0 // Highest wave index reached
		high_waves = 0 // Number of consecutive waves
		total_score = 0 // Across all sessions played

		update_scores = FALSE // Whether score has changed
		hub_scoring  = FALSE // Whether high scores were successfully retrieved from hub and scoring is enabled

		updating_score = FALSE // Whether update loop is currently running

	proc
		is_guest()
			return ( (copytext(key,1,6)=="Guest") \
			      || (copytext(key,1,12)=="Flash@Guest") \
			      || (copytext(key,1,12)=="Telnet@Guest") )

		reset_score()
			score = 0
			waves = 0

		award_score(var/amount)
			total_score += amount
			score += amount
			update_scores = TRUE
			if(score > high_score)
				high_score = score

		award_wave(var/new_wave)
			// Increase consecutive waves
			waves++
			if(waves >= high_waves)
				high_waves = waves
				update_scores = TRUE

			// Increase max wave
			if(new_wave > high_wave)
				high_wave = new_wave
				update_scores = TRUE

			update_hub() //### Submit scores after each wave

		update_hub()
			if(!updating_score && update_scores && !is_guest())
				updating_score = TRUE

				spawn()

					// Disconnect process from client, so if the player logs out the score is still submitted
					var
						client/owner = src
						owner_key = src.key
						owner_hub_scoring = src.hub_scoring
					src = null

					var
						tries_without_client = 10
						tries_until_warning = 4
						time_delay = 20
						success = null

						score_params = null

					while(TRUE)

						// If the client is still connected, keep the scores up-to-date
						if(owner)
							score_params = list( "Score" = num2text(owner.high_score, 12), \
							                     "Wave" = owner.high_wave, \
							                     "Consecutive Waves" = owner.high_waves ,\
							                     "Total Score" = num2text(owner.total_score, 12) )

							owner_hub_scoring = owner.hub_scoring

						// Check if we've retrieved previous high-scores before submitting new ones
						if(owner_hub_scoring)

							success = world.SetScores(owner_key, list2params(score_params))

							// Stop if we successfully submitted scores
							if(!isnull(success))
								break

							// If the client is gone, we only try a few times to prevent overriding new scores
							if(!owner && --tries_without_client <= 0)
								break

							// Show a warning if we fail to connect 'n' times
							if(owner && tries_until_warning > 0)
								tries_until_warning--
								if(tries_until_warning <= 0)
									// Warn them their scores are not being submitted
									owner << "\n<span class=\"system notice\" style=\"color: #DD0000;\">WARNING: Server failed to contact " \
									       + "the hub to submit your score. The server will continue to retry its connection; you will be " \
									       + "notified if it is successful.</span>\n"

							// Increase delay, max delay of 15 seconds
							time_delay = min(time_delay * 1.75, 150)

						else if(!owner)
							// If we never established a connection to the hub, and
							//  the client is gone, give up
							break

						sleep(time_delay)

					if(owner)
						if(tries_until_warning <= 0)
							// If we warned them that there was no connection, tell them it has been fixed
							owner << "\n<span class=\"system notice\" style=\"color: #DD0000;\">NOTICE: Server successfully " \
							       + "contacted the hub and submitted your score.</span>\n"

						// Loop is no longer running, can start a new one
						owner.updating_score = FALSE
						owner.update_scores = FALSE

		retrieve_scores()
			spawn(1)
				if(is_guest()) return

				// Disable sending scores to hub until we retrieve current high scores
				hub_scoring = FALSE

				var
					tries_until_warning = 4
					time_delay = 20
					score_params = null

				while(TRUE)
					// Attempt to get scores from hub
					score_params = world.GetScores(key)

					if(!isnull(score_params))
						// Successfully retrieved scores
						break

					// Show a warning if we fail to connect 'n' times
					if(tries_until_warning > 0)
						tries_until_warning--
						if(tries_until_warning <= 0)
							// Warn them their scores are not being submitted
							src << "\n<span class=\"system notice\" style=\"color: #DD0000;\">WARNING: Server failed to contact the " \
							     + "hub to retrieve your existing score. <u>Scores from your current session are not being submitted</u>. " \
							     + "The server will continue to retry its connection; you will be notified if it is successful.</span>\n"

					sleep(time_delay)
					time_delay = min(time_delay * 1.75, 150) // Increase delay, max delay of 15 seconds


				if(tries_until_warning <= 0)
					// If we warned them that there was no connection, tell them it has been fixed
					src << "\n<span class=\"system notice\" style=\"color: #DD0000;\">NOTICE: Server successfully contacted the hub " \
					     + "and retrieved your existing score. Scores from your current session will now be submitted.</span>\n"

				var/list/params = params2list(score_params)

				// Load scores if they're higher than current values
				high_score = max((text2num(params["Score"]) || 0), high_score)
				high_wave = max((text2num(params["Wave"]) || 0), high_wave)
				high_waves = max((text2num(params["Consecutive Waves"]) || 0), high_waves)
				total_score = max((text2num(params["Total Score"]) || 0), total_score)

				// Display score to player
				if(params.len)
					src << "\n<i>Welcome back, [key]! Here's your current high-scores:</i>\n" \
					     + "	<b>High Score:</b>			[num2text(high_score, 12)]\n" \
					     + "	<b>Furthest Wave:</b>		[high_wave]\n" \
					     + "	<b>Longest Wave Streak:</b>	[high_waves]\n" \
					     + "	<b>Total Score:</b>			[num2text(total_score, 12)]\n"
				else
					src << "\n<i>Welcome to Casual Quest, [key]!</i>\n" \
					     + "Please read the <b><a href=\"?src=\ref[src];action=show_help;\">help file</a></b> " \
					     + "to learn the controls. Have fun!\n"

				// We can now submit scores without worrying about overriding better high scores
				hub_scoring = TRUE

game/hero/subscriber
	scoring = FALSE

game/hero/custom
	scoring = FALSE

game/hero
	var
		scoring = TRUE

	proc
		award_score(var/amount)
			if(!scoring) return
			if(!player) return
			player.award_score(amount)