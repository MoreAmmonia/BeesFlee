extends Node3D
@export var debug=false
@export var touching_mode=true
@export var honey=0
@export var pollen=0
@export var capacity=1000
@export var convertrate=100
@export var toolswingspeed=2
@export var movespeed=5
var pollenpersec=0
var pollenlastsec=0
var GatherData
@export var ItemData=[0,5,4,5000,6,7,2,1]

func _ready():
	GatherData=JSON.parse_string(FileAccess.open("res://Data/Gather.json",FileAccess.READ).get_as_text())

func gather(size,color,field,rangename):
	var amount=size*GatherData[rangename]['white']
	if pollen<capacity:
		pollen=min(pollen+amount,capacity)
	if %PlayerData.debug:
		pollen=pollen+amount

func _process(delta):
	get_node("../Player").set_tool_speed(toolswingspeed)
	get_node("../Player").set_move_speed(movespeed)
	pollen=int(pollen)


func _on_timer_timeout():
	if pollen>pollenlastsec:
		pollenpersec=pollen-pollenlastsec
	else:
		pollenpersec=0
	pollenlastsec=pollen
