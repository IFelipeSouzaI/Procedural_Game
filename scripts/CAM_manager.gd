extends Node

onready var cam = get_parent().get_node("cam")

func _on_object_player_LimitCross(qdX, qdY):
	cam.global_position = Vector2((160*qdX), (144*qdY))
	pass
