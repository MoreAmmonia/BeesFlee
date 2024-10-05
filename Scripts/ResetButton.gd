extends Button

func _pressed():
	$ConfirmationDialog.show()
	
func  _process(delta):
	if Input.is_action_just_pressed('menu_reset'):
		$ConfirmationDialog.show()
