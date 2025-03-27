extends Area2D
class_name laser
@export var speed: float = 670

func _process(delta: float) -> void:
	position.y -= speed * delta  
	if position.y < -100:
		queue_free()
		
