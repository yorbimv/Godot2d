extends Area2D

export(String,  FILE, "*.tscn") var next_level
signal Goal

func _ready():
	BG_Music.stop()
	
func _physics_process(delta):
	var Bodies = get_overlapping_bodies()
	for i in Bodies:
		if i.name == "Player":
			emit_signal("Goal")
			if !$NextLevelSound.is_playing():
				BG_Music.stop()
				$NextLevelSound.play()
				

func _on_NextLevelSound_finished():
	get_tree().change_scene(next_level)
