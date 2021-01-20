extends CPUParticles2D

func _ready():
	self.emitting = true
	pass

func _on_timer_timeout():
	queue_free()
	pass
