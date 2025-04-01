extends Area2D

@export var speed: float = 400
@onready var sprite: Sprite2D = $Sprite2D  

var tiros_recebidos: int = 0
var imagens_abutre = [
	preload("res://Assets/abutresolo.png"),
	preload("res://Assets/abutredano1.png"),
	preload("res://Assets/abutredano2.png")
]

func _process(delta: float) -> void:
	var direction = Input.get_axis("esquerda", "direita")
	
	if direction != 0:
		position.x += direction * speed * delta
		sprite.flip_h = direction < 0 

func receber_tiro() -> void:
	tiros_recebidos += 1

	# Atualiza o sprite apenas se houver uma nova textura disponível
	if tiros_recebidos < imagens_abutre.size():
		sprite.texture = imagens_abutre[tiros_recebidos]

	# Se o abutre levou 3 tiros, ele desaparece
	if tiros_recebidos >= 3:
		queue_free()
