extends KinematicBody2D

var hp = 5
var dust = 1
var damage = 1

var velocity = Vector2.ZERO
var speed = -18

onready var detector = $detector

func _ready():
	add_to_group("E")
	randomize()
	speed = int(rand_range(18,24))*-1
	if randi()%2:
		speed *= -1
		detector.rotation_degrees *= -1
		$sprite.flip_h = !$sprite.flip_h
	set_physics_process(true)
	pass

func _physics_process(_delta):
	
	velocity.y += 10
	
	if detector.is_colliding():
		detector.rotation_degrees *= -1
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
