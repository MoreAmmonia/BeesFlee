extends Button


func _pressed():
	if name=="ResumeButton":
		get_node("../..").hide()
	else:
		get_node("..").hide()
