extends Control
var speed
@export var uiscale=1.0
var mouse_scrolling=false
var item_on_cursor=true
var ItemJson=JSON.parse_string(FileAccess.open("res://Data/Item.json",FileAccess.READ).get_as_text())

func mouse_entered():mouse_scrolling=true
func mouse_exited():mouse_scrolling=false

func _process(delta):
	if !%PlayerData.debug:uiscale=max(1,get_viewport().size.y/550)
	if Input.is_action_just_pressed("gui_debug"):%PlayerData.debug=!%PlayerData.debug
	if Input.is_action_just_pressed("gui_touch"):%PlayerData.touching_mode=!%PlayerData.touching_mode
	if %PlayerData.debug:
		$Debug.visible=true
	else:
		$Debug.visible=false
	if %PlayerData.pollenpersec:speed=' ('+str(%PlayerData.pollenpersec)+'/sec)'
	else:speed=''
	get_node("PollenHoney/PollenBar/MarginContainer/HBoxContainer/MarginContainer/Text/Data").text=str(%PlayerData.pollen)+"/"+str(%PlayerData.capacity)+speed
	get_node("PollenHoney/HoneyBar/MarginContainer/HBoxContainer/MarginContainer/Text/Data").text=str(%PlayerData.honey)
	get_node("PollenHoney/PollenBar/MarginContainer/HBoxContainer/MarginContainer/Text/ProgressBar").value=%PlayerData.pollen*100.0/%PlayerData.capacity
	get_node("PollenHoney/PollenBar/MarginContainer/HBoxContainer/MarginContainer/Text/ProgressBar").get("theme_override_styles/fill").set("bg_color",Color(%PlayerData.pollen*1.0/%PlayerData.capacity,1-%PlayerData.pollen*1.0/%PlayerData.capacity,0))
	$JoyStick.position=Vector2(get_viewport().size.x*(0.1),get_viewport().size.y*(0.8))
	$JoyStick.scale=Vector2(max(uiscale/4.0,0.25),max(uiscale/4.0,0.25))
	$SideBar/ItemButton.custom_minimum_size.x=uiscale*64
	$SideBar/QuestButton.custom_minimum_size.x=uiscale*64
	$SideBar/BeesButton.custom_minimum_size.x=uiscale*64
	$SideBar/BadgeButton.custom_minimum_size.x=uiscale*64
	$SideBar/SettingsButton.custom_minimum_size.x=uiscale*64
	$SideBar/ShopButton.custom_minimum_size.x=uiscale*64
	$SideBar.size.y=uiscale*64
	$PollenHoney.scale=Vector2(uiscale,uiscale)
	$SideBar.position.y=uiscale*100
	$MenuButton.scale=Vector2(uiscale,uiscale)
	$Menu/Menu.scale=Vector2(uiscale,uiscale)
	$ScrollLists.scale=Vector2(uiscale,uiscale)
	$ScrollLists.position.y=164*uiscale
	$Cursor.scale=Vector2(uiscale,uiscale)
	if %PlayerData.touching_mode:
		$ScrollLists.size.y=($JoyStick.position.y*2-get_viewport().size.y-$ScrollLists.position.y)/uiscale
		$JoyStick.visible=true
	else:
		$ScrollLists.size.y=get_viewport().size.y/uiscale-324
		$JoyStick.visible=false
	$Cursor.position=get_viewport().get_mouse_position()-Vector2(40,40)*uiscale
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and item_on_cursor:
		$Cursor.visible=false
		if !mouse_scrolling:
			use_item(item_on_cursor)
		item_on_cursor=0
	#print(mouse_scrolling)

func _on_confirmation_dialog_confirmed():
	$Menu.hide()
	get_node("../Player").reset()

func refresh():
	var ItemPrefab=load("res://Scenes/Sidebar/ListItem.tscn")

	for InstancedItem in $ScrollLists/ItemList/VBoxContainer.get_children():
		InstancedItem.queue_free()
	for ItemIndex in range(999):
		if var_to_str(ItemIndex) in ItemJson and %PlayerData.ItemData[ItemIndex]>0:
			var ItemAttr=ItemJson[var_to_str(ItemIndex)]
			var ItemInstance=ItemPrefab.instantiate()
			ItemInstance.init(ItemAttr['icon'],ItemAttr['name'],ItemAttr['intro'],%PlayerData.ItemData[ItemIndex],ItemIndex)
			$ScrollLists/ItemList/VBoxContainer.add_child(ItemInstance)
	#print(ItemJson)
	pass

func use_item(id:int):
	print('activated!')
	if %PlayerData.ItemData[id] > 0 :
		%PlayerData.ItemData[id]=%PlayerData.ItemData[id]-1;
	refresh()

func holding_item(id,pict):
	item_on_cursor=id
	if id:
		$Cursor.texture=load("res://Textures/Item/"+ItemJson[var_to_str(id)]['icon']+".png")
	$Cursor.visible=true
	


