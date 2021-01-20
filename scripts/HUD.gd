extends Node2D

var upDust = 0
var enemyExplo = preload("res://scenes/objects/object_enemyExplo.tscn")

func _ready():
	var _e = player.connect("shield_Dust",self,"heartUp")
	pass

func heartUp(value, Eposition):
	upDust += value
	e_instance(enemyExplo,Eposition)
	if upDust >= 40 and player.hp < 4:
		player.hp += 1
		$hp.value = player.hp
		upDust = 0
	$heartBar.value = upDust
	pass

func e_instance(scene, pos):
	var e = scene.instance()
	e.global_position = pos
	get_parent().get_parent().add_child(e)
	pass

func _on_object_player_Info():
	$hp.value = player.hp
	pass
