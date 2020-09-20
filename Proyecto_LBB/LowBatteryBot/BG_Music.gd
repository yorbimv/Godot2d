extends AudioStreamPlayer

var PlayMusic = true

func _process(delta):
	if get_tree().get_current_scene().get_name() == "GameOver":
		pass
		#PlayMusic = false
		
	if Input.is_action_just_pressed("M"):
		if PlayMusic == true:
			PlayMusic = false
		else:
			PlayMusic = true

		if PlayMusic == true:
			play()
		else:
			stop()