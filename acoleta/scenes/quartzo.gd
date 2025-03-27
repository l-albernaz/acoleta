extends Area2D

class_name quartzo

signal gemasai

@export var speed: float = 330

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta
	
	if position.y < -80:
		gemasai.emit()
		set_process(false)
		queue_free()
	
	
