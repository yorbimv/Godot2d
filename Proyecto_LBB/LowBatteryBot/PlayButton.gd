extends Button


func _ready():
	rect_scale.x = .9
	rect_scale.y = .9
	BG_Music.stop()
	
func _on_PlayButton_mouse_entered():
	rect_scale.x = 1
	rect_scale.y = 1
	


func _on_PlayButton_mouse_exited():
	rect_scale.x = .9
	rect_scale.y = .9


func _on_PlayButton_pressed():
	rect_scale.x = .9
	rect_scale.y = .9
	get_tree().change_scene("Level_1.tscn")
