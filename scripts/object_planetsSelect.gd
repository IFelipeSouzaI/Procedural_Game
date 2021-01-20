extends Node2D

var WORKING = "ICONS"
var n = 0
var m = 0
var iconsN = [4,3,6,4]

func _ready():
	set_process(true)
	att_Planets()
	pass

func _process(_delta):
	
	if Input.is_action_just_pressed("Interact"):
		get_parent().operating = false
		get_tree().paused = false
		queue_free()
	
	if WORKING == "ICONS":
		
		if Input.is_action_just_pressed("SHOT"):
			get_parent().operating = false
			get_tree().paused = false
			queue_free()
		
		if Input.is_action_just_pressed("RIGHT"):
			n += 1
			att_Planets()
		elif Input.is_action_just_pressed("LEFT"):
			n -= 1
			att_Planets()
		
		if Input.is_action_just_pressed("JUMP"):
			get_node("lvs/lv"+str(n)).show()
			m = 0
			att_Icons()
			WORKING = "PLANETS"
	
	elif WORKING == "PLANETS":
		if Input.is_action_just_pressed("JUMP"):
			WORKING = "NONE"
			get_tree().paused = false
			$anim.play("out")
		
		if Input.is_action_just_pressed("RIGHT"):
			m += 1
			att_Icons()
		elif Input.is_action_just_pressed("LEFT"):
			m -= 1
			att_Icons()
		
		if Input.is_action_just_pressed("SHOT"):
			get_node("lvs/lv"+str(n)).hide()
			WORKING = "ICONS"
	
	pass

func att_Icons():
	if m < 0:
		m = player.lvUnlocked[n]-1
	elif m > player.lvUnlocked[n]-1:
		m = 0
	for x in range(iconsN[n]):
		if x == m and get_node("lvs/lv"+str(n)+"/icon"+str(x)).frame <= 6:
			get_node("lvs/lv"+str(n)+"/icon"+str(x)).frame = get_node("lvs/lv"+str(n)+"/icon"+str(x)).frame+7
		elif get_node("lvs/lv"+str(n)+"/icon"+str(x)).frame > 6 and x != m:
			get_node("lvs/lv"+str(n)+"/icon"+str(x)).frame = get_node("lvs/lv"+str(n)+"/icon"+str(x)).frame-7
	pass

func att_Planets():
	if n < 0:
		n = 3
	elif n > 3:
		n = 0
	for x in range(4):
		if x == n:
			$planets.get_node("p"+str(x)).frame = $planets.get_node("p"+str(x)).frame+4
		elif $planets.get_node("p"+str(x)).frame > 3:
			$planets.get_node("p"+str(x)).frame = $planets.get_node("p"+str(x)).frame-4
	$planet.frame = n
	pass

func _on_anim_animation_finished(anim_name):
	if anim_name == "out":
		var _e = get_tree().change_scene("res://scenes/game/game_main.tscn")
	pass
