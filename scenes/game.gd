extends Node2D

const FIMDEJOGO = preload("res://Assets/SONS/FIMDEJOGO.mp3")
const LANCA_ATINGIRR = preload("res://Assets/SONS/lanca atingirr.mp3")
const DIAMOND_FOUND_190255 = preload("res://Assets/SONS/diamond-found-190255.mp3")

@export var ametista_scene: PackedScene
@export var quartzo_scene: PackedScene

@onready var label: Label = $Label
@onready var labeltempo: Label = $Labeltempo
@onready var ametista_timer: Timer = $AmetistaTimer
@onready var quartzo_timer: Timer = $QuartzoTimer
@onready var tempojogo: Timer = $tempojogo
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var tiros_no_abutre: int = 0
var _pontos: int = 0
var tempo_restante: int = 110

func _ready() -> void:
	ametista_timer.wait_time = 14.4  
	quartzo_timer.wait_time = 1.6   
	
	ametista_timer.one_shot = false
	quartzo_timer.one_shot = false
	
	ametista_timer.timeout.connect(criagema_ametista)
	quartzo_timer.timeout.connect(criagema_quartzo)
	
	ametista_timer.start()
	quartzo_timer.start()
	
	tempojogo.timeout.connect(atualizar_tempo)
	tempojogo.start()
	
	atualizar_tempo_label()

func criagema_ametista() -> void:
	criagema(ametista_scene)

func criagema_quartzo() -> void:
	criagema(quartzo_scene)

func criagema(scene: PackedScene) -> void:
	var novagema = scene.instantiate()
	novagema.position = Vector2(randf_range(80, 1000), 600)
	add_child(novagema)

func atualizar_tempo() -> void:
	tempo_restante -= 1
	atualizar_tempo_label()
	
	if tempo_restante <= 0 or _pontos >= 100:
		encerrar()

func atualizar_tempo_label() -> void:
	labeltempo.text = "%03d" % tempo_restante

func encerrar() -> void:
	ametista_timer.stop()
	quartzo_timer.stop()
	tempojogo.stop()
	
	for child in get_children():
		child.set_process(false)

	labeltempo.text = "Fim de Jogo!"
	pararsom()

func pararsom() -> void:
	audio_stream_player.stop()
	audio_stream_player_2d.stop()
	audio_stream_player_2d.stream = FIMDEJOGO
	audio_stream_player_2d.play()

func _on_abutre_area_entered(area: Area2D) -> void:
	
	var pontos_gema = 0
	
	if area is ametista:
		pontos_gema = 10
	elif area is quartzo:
		pontos_gema = 2
	elif area is laser:
		tiros_no_abutre += 1
		area.queue_free()  # Remove o laser imediatamente após o impacto
		
		# Muda a imagem do Abutre ao ser atingido
		var abutre = get_node("Abutre")  # Certifique-se de que o caminho está correto
		if abutre:
			abutre.receber_tiro()

		if tiros_no_abutre >= 3:
			encerrar()
			return  # Evita que o código continue rodando após o encerramento
	
	# Atualiza pontuação apenas uma vez
	_pontos += pontos_gema
	label.text = "%03d" % _pontos
	
	# Reproduz o som adequado
	audio_stream_player_2d.position = area.position * 1.5
	if pontos_gema > 0:
		audio_stream_player_2d.stream = DIAMOND_FOUND_190255
	elif area is laser:
		audio_stream_player_2d.stream = LANCA_ATINGIRR
	audio_stream_player_2d.play()
	
	area.queue_free()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
