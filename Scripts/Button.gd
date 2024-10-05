extends Button



func _pressed():
	if get_node("../../Menu").visible:
		get_node("../../Menu").hide()
	else:
		get_node("../../Menu").show()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_pressed()
