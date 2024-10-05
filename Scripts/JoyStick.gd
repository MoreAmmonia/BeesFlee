extends Sprite2D

var ondragging=-1
func _input(event):
	if (event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed())) and event.get_index()!=get_node("/root/World/Player").ondragging:
		var mouselen=(event.position-self.position).length()
		#if mouselen<=128*scale.x or ondraging==event.get_index():
		if mouselen<=256*scale.x or ondragging==event.get_index():
			ondragging=event.get_index()
			$Button.set_global_position(event.position)
			if $Button.position.length()>256:
				$Button.set_position($Button.position.normalized()*256)
	if event is InputEventScreenTouch and !event.is_pressed():
		$Button.position=Vector2(0,0)
		ondragging=-1

func _process(_delta):
	pass
	#position=Vector2(get_viewport().size.x*(0.1),get_viewport().size.y*(0.8))
	#scale=Vector2(max(get_viewport().size.y/500*0.25,0.25),max(get_viewport().size.y/500*0.25,0.25))
