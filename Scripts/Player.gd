extends CharacterBody3D

@onready var camera_mount = $CameraMount

var SPEED = 5.0
var JUMP_VELOCITY = 30
var shift_lock=false
@export var sens_horizontal=0.5
@export var sens_vertical=0.5
@export var camera_zoom=2
var toolusing=false
var ondragging=-1

#var JoyStick=get_node("/root/World/InGameGUI/JoyStick")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_tool_speed(speed):
	get_node("RobloxModel").set_speed(speed)
	
func set_move_speed(speed):
	SPEED=speed

func reset():
	position=Vector3(0,0,0)
	%PlayerData.pollen=0
	
func _process(_delta):
	$ToolHandle.rotation.x=deg_to_rad($RobloxModel/RAM.rotation_degrees.x)
	$RobloxModel/ArmRight.rotation.x=deg_to_rad($RobloxModel/RAM.rotation_degrees.x)
	if $ToolHandle.rotation_degrees.x<10 and toolusing==false:
		var range=load("res://Scenes/Range/PorcelainDipper.tscn").instantiate()
		add_child(range)
		toolusing=true
		#range.initalize(Vector3(1,1,1))
	if $ToolHandle.rotation_degrees.x>10:
		toolusing=false

func _input(event):
	if event is InputEventScreenTouch and !event.is_pressed():ondragging=-1
	if (event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)) or event is InputEventScreenDrag:
	#if event is InputEventScreenDrag:
		#print(get_viewport().size)
		if event is InputEventScreenDrag:
			if (event.position.x<get_viewport().size.x/2 and event.get_index()!=ondragging) or (get_node("/root/World/InGameGUI/JoyStick").ondragging==event.get_index() and get_node("/root/World/InGameGUI/JoyStick").ondragging!=-1):return
			ondragging=event.get_index()
		if shift_lock:
			rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		else:
			if %PlayerData.debug==false:
				Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
			#camera_mount.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))
			rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))
			if camera_mount.rotation_degrees[0]< -90:
				camera_mount.rotation.x=deg_to_rad(-90)
			if camera_mount.rotation_degrees[0]> 45:
				camera_mount.rotation.x=deg_to_rad(45)
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if !$"../InGameGUI".mouse_scrolling:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
			camera_zoom-=0.3
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
			camera_zoom+=0.3
	if camera_zoom<1:
			camera_zoom=1
	if camera_zoom>3:
			camera_zoom=3
	camera_mount.get_child(0).position.z=camera_zoom
	

func _physics_process(delta):
	if not is_on_floor():
		#velocity.y -= gravity * delta
		velocity.y -= gravity * delta * 2

	if Input.is_action_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY*0.3

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir==Vector2(0,0):
		input_dir=Vector2(get_node("/root/World/InGameGUI/JoyStick/Button").position.x/10.0,get_node("/root/World/InGameGUI/JoyStick/Button").position.y/10.0)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		#print(get_node("/root/World/InGameGUI/JoyStick/Button").position)
	move_and_slide()
