extends Node2D

var n = 0
var control_offset = 0
var pos = [86,100,114]
var started = false
var windows = ["","res://scenes/objects/object_aboutW.tscn"]


func _ready():
	randomize()
	set_process(true)
	pass

func _process(delta):
	
	control_offset -= 8*delta
	$paralax.scroll_offset.x = control_offset
	
	if started:
		if Input.is_action_just_pressed("UP"):
			n -= 1
		if Input.is_action_just_pressed("DOWN"):
			n += 1
		
		if n < 0:
			n = 2
		elif n == 3:
			n = 0
		
		$selectBar.global_position.y = pos[n]
		
		if Input.is_action_just_pressed("JUMP"):
			if n == 0:
				$anim.play("out")
			elif n != 1:
				w_instance(n-1)
			started = false
	
	pass

func w_instance(t):
	var w = load(windows[t]).instance()
	w.global_position = Vector2(80,72)
	add_child(w)
	pass

func _on_anim_animation_finished(anim_name):
	if anim_name == "in":
		started = true
	elif anim_name == "out":
		var _e = get_tree().change_scene("res://scenes/game/game_markTalk.tscn")
	pass
