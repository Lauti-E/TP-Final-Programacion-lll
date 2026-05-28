extends Node2D

@export var escenaAsteroide: PackedScene

@export var tiempoMin: float = 0.0
@export var tiempoMax: float = 0.0

func _ready():
	await get_tree().create_timer(5.0).timeout
	SpawnLoop()

func SpawnLoop():
	while true:
		SpawnearAsteroide()
		
		await get_tree().create_timer(tiempoMin, tiempoMax).timeout

func SpawnearAsteroide():
	if escenaAsteroide == null:
		return
	
	var asteroide = escenaAsteroide.instantiate()
	var ancho = get_viewport_rect().size.x
	var margen = 20
	
	var randomX = randf_range(margen, ancho - margen)
	
	asteroide.global_position = Vector2(randomX, -50)
	
	get_tree().current_scene.add_child.call_deferred(asteroide)
