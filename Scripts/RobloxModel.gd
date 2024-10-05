extends Node3D
var swingspeed=1
var ScreenIsTouching=false
func set_speed(speed):
	swingspeed=speed

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			ScreenIsTouching=true
		else:
			ScreenIsTouching=false

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or ScreenIsTouching:
		$AnimGather.speed_scale=swingspeed
		$AnimGather.play("RobloxGather")
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or get_node("/root/World/InGameGUI/JoyStick").ondragging!=-1:
		$AnimMove.play("RobloxMove")
	else:
		$AnimMove.stop()
