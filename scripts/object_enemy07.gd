extends KinematicBody2D

var hp = 5
var dust = 2
var damage = 1

var velocity = Vector2.ZERO
var speed = -24

func _ready():
	add_to_group("E")
	randomize()
	speed = int(rand_range(24,30))*-1
	if randi()%2:
		speed *= -1
		$sprite.flip_h = !$sprite.flip_h
	if randi()%2:
		$anim.play("flyII")
	set_physics_process(true)
	pass

func _physics_process(delta):
	
	velocity.y = speed
	
	var colision = move_and_collide(velocity*delta)
	if colision:
		speed*=-1
	
	pass

func apply_damage(value):
	hp -= value
	if hp < 0:
		player.emit_signal("shield_Dust", dust, global_position)
		queue_free()
	pass
