extends Node2D

var gameManager

@export var escenaAsteroide: PackedScene

@export var tiempoMin: float = 0.0
@export var tiempoMax: float = 0.0

func _ready():
	gameManager = get_tree().get_first_node_in_group("GameManager")
	
	SpawnLoop()

func SpawnLoop():
	while true:
		
		if gameManager.generarAsteroide and !gameManager.eventoBossActivo: 
			SpawnearAsteroide()
		
		await get_tree().create_timer(
			randf_range(
				gameManager.tiempoAsteroideMin,
				gameManager.tiempoAsteroideMax
			)
		).timeout
		
func SpawnearAsteroide():
	if escenaAsteroide == null:
		return
	
	var asteroide = escenaAsteroide.instantiate()
	var ancho = get_viewport_rect().size.x
	var margen = 20
	
	var randomX = randf_range(margen, ancho - margen)
	
	asteroide.global_position = Vector2(randomX, -50)
	
	get_tree().current_scene.add_child.call_deferred(asteroide)
