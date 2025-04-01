extends Area2D

@export var speed: float = 650
@export var laser_scene: PackedScene 

@onready var drone: Sprite2D = $Drone

var podeatirar = true

func _process(delta: float) -> void:
	var direction = Input.get_axis("esquerda2", "direita2")
	
	if direction != 0:
		position.x += direction * speed * delta
		
	if Input.is_action_just_pressed("atirar2"):
		atirar()
		
		

func atirar() -> void:
	if not podeatirar:
		return 

	podeatirar = false 

	var laser = laser_scene.instantiate()
	laser.position = position + Vector2(7, -50)
	get_parent().add_child(laser)

	await get_tree().create_timer(1.5).timeout  

	podeatirar = true  
