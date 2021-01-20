extends Node2D

var inst = preload("res://scenes/objects/object_instructions.tscn")
var planetsSelect = preload("res://scenes/objects/object_planetsSelect.tscn")

var startWords = ["We need get the data of\nof these planets...",
"as soon as possible.",
"But, before you leave...",
"In case you want to\nreview some instructions.",
"Go to the computer and\npress C or Circle | B.      ",
"If you feel confident\nenough to start...",
"Go to the chamber in the\nright corner...",
"and press C, or, Circle | B.",
"Good Luck . . .",
"Again, go to the chamber\nand press C",
"To start your adventure."]

onready var player = get_parent().get_node("object_player")

var operating = false
var t = 0

func _ready():
	$words.text = startWords[t]
	$words.visible_characters = 0
	set_process(true)
	pass

func _process(_delta):
	
	if !operating:
		if Input.is_action_just_pressed("Interact"):
			if player.global_position.distance_to(Vector2(86,128)) < 16:
				get_tree().paused = true
				i_instance(inst)
				operating = true
			elif player.global_position.distance_to(Vector2(136,128)) < 16:
				get_tree().paused = true
				i_instance(planetsSelect)
				operating = true 
	
	pass

func _on_timer_timeout():
	if $words.visible_characters != $words.get_total_character_count()+60:
		$words.visible_characters = $words.visible_characters+1
	elif t < 10:
		$words.visible_characters = 0
		t += 1
		$words.text = startWords[t]
	else:
		show_Box(false)
	if $timer.wait_time == 2:
		$timer.wait_time = 0.05
	$timer.start()
	pass

func i_instance(scene):
	var i = scene.instance()
	i.global_position = Vector2(80,72)
	add_child(i)
	pass

func show_Box(value):
	$box.visible = value
	$words.visible = value	
	pass
