extends KinematicBody2D

var motion = Vector2()
var SP = 280 #Max Speed
const UP = Vector2(0,-1)
var Acc = 10 #Accelerarion
var Battery = 100
var xstart = position.x
var ystart = position.y
var Charging = false #Is Charging?
var ChargeVal = 50 #Charge Value
#signal Energy
var Ready = false
var Blinking = false
var StepFX = false #is off and not going to work because it sound terrible :(

func _ready():
	xstart = position.x
	ystart = position.y
	$Control/Canvas/ReadyPosition/ReadyText.hide()
	
func _physics_process(delta):
	#Check for step sound FX
	if $StepsSound.is_playing():
		StepFX = false
	
	if is_on_floor() && motion.x > 10 || motion.x < -10:
		if StepFX:
			$StepsSound.play()
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene() #Restart level
		
	motion.y += 20 #Start Gravity
	if motion.y >= 680:
		motion.y = 680
	var friction = false
	
	
	if Input.is_action_pressed("ui_right") && Ready:
		motion.x += Acc
		motion.x = min(motion.x+Acc,SP)
		
		#Sprites control?
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left") && Ready:
		motion.x -= Acc
		motion.x = max(motion.x-Acc, -SP)
		
		#Sprite Control for left direction?
		$Sprite.flip_h = true
		$Sprite.play("Run")
	else:
		$Sprite.play("Stand")
		friction = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up") && Ready:
			motion.y = -SP*2
			#$JumpSound.play()
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.3) #Slow down
	else:
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.5) #Slow down more on the air
			
	motion = move_and_slide(motion, UP)
	
	#Health Bar Update
	$Control/Canvas/Position2D/BarSprite.value = Battery

	#Battery Charging control
	if Charging && ChargeVal >0:
		ChargeVal -= 1
		Battery += 1
	if ChargeVal <= 0:
		Charging = false;
	if Battery > 100:
		Battery = 100
		Charging = false
		ChargeVal = 0
		
	#Sprite Green Yello Red for Bar
	if Battery > 50:
		$Control/Canvas/Position2D/BarSprite.texture_progress = load("res://Sprites/spr_bar_green.png")
	elif Battery > 20 && Battery <= 50:
		$Control/Canvas/Position2D/BarSprite.texture_progress = load("res://Sprites/spr_bar_yellow.png")
	elif Battery <= 20:
		$Control/Canvas/Position2D/BarSprite.texture_progress = load("res://Sprites/spr_bar_red.png")
		
	
	#Control Music Speed
	if Battery < 30:
		BG_Music.set_pitch_scale(1.1)
	else:
		BG_Music.set_pitch_scale(1)
func _on_BatteryTimer_timeout():
	if Battery > 0 && !Charging:
		Battery -= 1
	elif Battery <= 0:
		get_tree().reload_current_scene() #Restart level
		#Battery = 100
		#position.x = xstart
		#position.y = ystart
	


func _get_energy():
	Charging = true
	ChargeVal += 50
	$BatterySound.play()
	$EnergySound.play()

func _on_StartGameTimer_timeout(): #Start Playing! READY!
	$Control/Canvas/ReadyPosition/ReadyText.show()
	$HideReadyTimer.start()
	$BatteryTimer.start()
	Ready = true
	if BG_Music.PlayMusic == true:
		BG_Music.play()


func _on_HideReadyTimer_timeout():
	$Control/Canvas/ReadyPosition/ReadyText.hide()


func _on_Spikes_Hit():
	if Blinking == false:
		$HitSound.play()
		Ready = false
		$HitTimer.start()
		$BlinkHideShowTimer.start()


func _on_HitTimer_timeout():
	Ready = true
	Blinking = true
	$BlinkingTimer.start()


func _on_BlinkingTimer_timeout():
	Blinking = false
	Ready = true
	$BlinkHideShowTimer.stop()
	$Sprite.modulate.a = 1


func _on_BlinkHideShowTimer_timeout():
	if $Sprite.modulate.a == 1:
		$Sprite.modulate.a = 0.5
	else:
		$Sprite.modulate.a = 1


func _on_StepsSound_finished():
	StepFX = true #True again so it can repeat step sound effect


func _level_complete_goal():
	Ready = false
	Charging = true
	ChargeVal = 100
