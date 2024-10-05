extends Node3D
enum FIELD_TYPE{Sunflower,Dandelion,Mushroom,Blueflower,Clover,Strawberry,Spider,Bamboo,Pineapple,Stump,Cactus,Pumpkin,Pinetree,Rose,MountainTop,Coconut,Pepper,Ant,Hub}
enum FLOWER_COLOR{White,Red,Blue}
@export var flowerlevel=4
@export var fieldtype: FIELD_TYPE=FIELD_TYPE.Sunflower
@export var flowercolor: FLOWER_COLOR=FLOWER_COLOR.White
@export var hasgoo=false
@export var flowersize=1
const SINK_DEPTH=0.1
const MAX_FLOWER_LEVEL=4

func _ready():
	_refresh()

func _gathered(rangename):
	_refresh()
	if flowerlevel>0:
		flowerlevel-=1
		get_node('/root/World/PlayerData').gather(1,0,0,rangename)
		$Timer.start()

func _on_timer_timeout():
	_refresh()
	if flowerlevel<MAX_FLOWER_LEVEL:
		flowerlevel+=1

func _refresh():
	#get_node("../PlayerData").gather(1,0,0)
	$FlowerBox.position.y=(flowerlevel-MAX_FLOWER_LEVEL)*SINK_DEPTH
	$FlowerBox/FlowerSprite.set("texture",load("res://Textures/Flowers/"+str(flowercolor)+str(flowersize)+".png"))

func _on_area_3d_area_entered(area):
	if area.get_node('Range')!=null:
		_gathered(area.get_node('Range').get_meta('Name'))
	_refresh()
