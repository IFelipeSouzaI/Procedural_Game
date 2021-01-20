extends KinematicBody2D

var SPEED = 56
var velocity = Vector2.ZERO
var ground = false
var energy = 200
onready var partc = $fly
var shot_OBJ = preload("res://scenes/objects/object_Pshot.tscn")
var shooting = false
var anim = ""
var quadrantX = 0
var quadrantY = 0
var hited = false
var on_door = false

export var inGame = true

signal LimitCross(qdX,qdY)
signal Info

func _ready():
	emit_signal("Info")
	set_physics_process(true)
	pass

func _physics_process(_delta):
	
	if on_door and Input.is_action_just_pressed("UP"):
		print("DOIENG GREAT")
	
	if (int(global_position.x/160) != quadrantX) || (int(global_position.y/144) != quadrantY):
		quadrantX = int(global_position.x/160)
		quadrantY = int(global_position.y/144)
		emit_signal("LimitCross", quadrantX, quadrantY)
	
	
	var RIGHT = Input.is_action_pressed("RIGHT")
	var LEFT = Input.is_action_pressed("LEFT")
	var JUMP = Input.is_action_just_pressed("JUMP")
	var JUMP_STOP = Input.is_action_just_released("JUMP")
	var FLY = Input.is_action_pressed("FLY")
	var FLY_RELEASED = Input.is_action_just_released("FLY")
	var SHOT = Input.is_action_pressed("SHOT")
	
	velocity.y += 5
	
	ground = false
	if $feet1.is_colliding() || $feet2.is_colliding():
		ground = true
		if energy < 200:
			if inGame:
				get_parent().get_node("HUD/HUD/gas").value = energy
			energy += 4
		else:
			energy = 200
			if inGame:
				get_parent().get_node("HUD/HUD/gas").value = energy
	
	if RIGHT:
		velocity.x = SPEED
		$shot_Pos.position = Vector2(10,0)
		$sprite.flip_h = false
		partc.position = Vector2(-2,7)
	elif LEFT:
		velocity.x = -SPEED
		$sprite.flip_h = true
		$shot_Pos.position = Vector2(-10,0)
		partc.position = Vector2(2,7)
	else:
		partc.gravity = Vector2(0,98)
		velocity.x = 0	
	
	if ground:
		if JUMP:
			velocity.y -= 120
		elif LEFT || RIGHT:
			animP("run")
		else:
			animP("idle")
	elif JUMP_STOP and velocity.y < 0:
			velocity.y *= 0.5
	else:
		if velocity.y < 0:
			animP("jump")
		else:
			animP("fall")
	
	
	if FLY and energy > 0:
		if inGame:
			get_parent().get_node("HUD/HUD/gas").value = energy
		partc.emitting = true
		velocity.y -= 6
		energy -= 2
	elif energy <= 10:
		partc.emitting = false
	if FLY_RELEASED:
		partc.emitting = false
	
	if SHOT and !shooting:
		shot_instance()
		$weapon/Wanim.play("shot")
		shooting = true
	
	velocity = move_and_slide(velocity)
	
	pass

func animP(new_anim):
	if anim != new_anim:
		$anim.play(new_anim)
		anim = new_anim
	pass

func shot_instance():
	var s = shot_OBJ.instance()
	s.global_position = $shot_Pos.global_position
	s.motion = $shot_Pos.position/10
	get_parent().add_child(s)
	pass

func apply_damage(value):
	player.hp -= value
	emit_signal("Info")
	pass

func up_sheart(hp, shield):
	player.hp += hp
	player.shield += shield
	emit_signal("Info")
	pass

func _on_damage_body_entered(body):
	if body.is_in_group("E") and !hited:
		apply_damage(body.damage)
		$sprite/damage.play("damage")
		hited = true
	elif body.is_in_group("Door"):
		on_door = true
		if !body.get_node("tip").is_visible():
			body.get_node("tip").show()
	pass

func _on_damage_body_exited(body):
	if body.is_in_group("Door"):
		on_door = false
	pass

func _on_damage_animation_finished(anim_name):
	if anim_name == "damage":
		$damage/shape.disabled = false
		hited = false
	pass

func _on_Wanim_animation_finished(anim_name):
	if anim_name == "shot":
		shooting = false
	pass

