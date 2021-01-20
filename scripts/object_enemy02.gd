extends KinematicBody2D

var hp = 5
var dust = 2
var damage = 1

export var distance = 16
var origin = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = -24

func _ready():
	add_to_group("E")
	
	randomize()
	speed = int(rand_range(18,30))*-1
	if randi()%2:
		speed *= -1
		$sprite.flip_h = !$sprite.flip_h
	origin = global_position
	
	set_physics_process(true)
	pass

func _physics_process(_delta):
	
	if global_position.distance_to(origin) >= distance:
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
