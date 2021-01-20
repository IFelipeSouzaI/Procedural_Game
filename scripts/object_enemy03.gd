extends KinematicBody2D

var hp = 5
var dust = 2
var damage = 1
var due = false
var n = 0
var dir = [Vector2(1,0),Vector2(0,-1),Vector2(-1,0),Vector2(0,1)]
var speed = -18
var velocity = Vector2.ZERO

func _ready():
	add_to_group("E")
	randomize()
	$timer.start()
	global_position.y += 4
	speed = int(rand_range(18,24))*-1
	set_physics_process(true)
	pass

func _physics_process(_delta):
	
	velocity = dir[n]*speed
	velocity = move_and_slide(velocity)
	
	if !$detector.is_colliding() and due:
		self.rotation_degrees -= 90
		$timer.wait_time = 1.0
		$timer.start()
		if n < 3:
			n += 1
		else:
			n = 0
		due = false
	
	pass

func apply_damage(value):
	hp -= value
	if hp < 0:
		player.emit_signal("shield_Dust", dust, global_position)
		queue_free()
	pass

func _on_timer_timeout():
	due = true
	pass
