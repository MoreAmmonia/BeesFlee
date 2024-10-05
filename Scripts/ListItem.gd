extends Control
@export var item_index=0
func init(pic,title,intro,amount,id):
	$HBoxContainer/Background/Button.icon=load("res://Textures/Item/"+pic+".png")
	$HBoxContainer/Content/Title.text=title
	$HBoxContainer/Content/Introduction.text=intro
	$HBoxContainer/Background/Button/Amount.text="x"+str(amount)
	item_index=id
	
func hold():
	$"../../../..".holding_item(item_index,1)

func pressed():
	$"../../../..".use_item(item_index)
