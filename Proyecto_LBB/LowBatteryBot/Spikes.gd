extends Area2D
signal Hit
func _physics_process(delta):
	var Bodies = get_overlapping_bodies()
	for i in Bodies:
		if i.name == "Player":
			emit_signal("Hit")
			


func _on_Spikes_Hit():
	$Timer.start()
	$CollisionShape2D.disabled = true

func _on_Timer_timeout():
	$CollisionShape2D.disabled = false
