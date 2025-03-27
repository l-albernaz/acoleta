extends Area2D

@export var speed: float = 400
@onready var sprite = $Sprite2D  

func _process(delta: float) -> void:
	var direction = Input.get_axis("esquerda", "direita")
	
	if direction != 0:
		position.x += direction * speed * delta
		sprite.flip_h = direction < 0 
