extends Area2D

var damage = 1
var motion = Vector2.ZERO
var speed = 128

var explo = "res://scenes/objects/object_shotExplo.tscn"

func _ready():
	set_process(true)
	pass

func _process(delta):
	move(motion, delta, speed)
	pass

func move(dir, delta, vel):
	move_local_x(dir.x*delta*vel)
	move_local_y(dir.y*delta*vel)
	pass

func e_instance():
	var e = load(explo).instance()
	e.global_position = global_position
	get_parent().add_child(e)
	pass

func _on_object_Pshot_body_entered(body):
	if body.is_in_group("E"):
		if body.has_method("apply_damage"):
			body.apply_damage(damage)
	e_instance()
	queue_free()
	pass
