extends KinematicBody2D

var hp = 5
var dust = 2
var damage = 1

var velocity = Vector2.ZERO
var speed = -18

onready var Wdetector = $wall_detector
onready var Fdetector = $fall_detector

func _ready():
	add_to_group("E")
	randomize()
	speed = int(rand_range(18,24))*-1
	if randi()%2:
		speed *= -1
		Fdetector.position = Vector2(6,0)
		Wdetector.rotation_degrees *= -1
		$sprite.flip_h = !$sprite.flip_h
	set_physics_process(true)
	pass

func _physics_process(_delta):
	
	velocity.y += 10
	
	if Wdetector.is_colliding() || !Fdetector.is_colliding():
		Wdetector.rotation_degrees *= -1
		Fdetector.position = Vector2(6,0)*(speed/abs(speed))*-1
		speed *= -1
		$sprite.flip_h = !$sprite.flip_h
	
	velocity.x = speed
	
	velocity = move_and_slide(velocity)
	
	pass

func apply_damage(value):
	hp -= value
	if hp < 0:
		player.emit_signal("shield_Dust", dust, global_position)
		queue_free()
	pass
