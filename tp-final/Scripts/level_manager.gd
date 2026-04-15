extends Node2D

@export var camara: Camera2D
@export var escenaSpawner: PackedScene

@export var distanciaEntreSpawners: float = 500
@export var offsetSpawn: float = 800

var ultimoSpawnY: float = 0.0

func _ready():
	if camara != null:
		ultimoSpawnY = camara.global_position.y

func _process(_delta):
	if camara == null:
		return
	
	var camY = camara.global_position.y
	
	if camY < ultimoSpawnY - distanciaEntreSpawners:
		
		CrearSpawner()
		
		var posSpawn = Vector2(
			camara.global_position.x,
			camara.global_position.y - offsetSpawn
		)
		
		var debug = ColorRect.new()
		debug.color = Color(0, 1, 0, 0.5)
		debug.size = Vector2(50, 50)
		debug.global_position = posSpawn
		
		get_tree().current_scene.add_child(debug)
		
		ultimoSpawnY = camY

func CrearSpawner():
	if escenaSpawner == null:
		print("No hay spawner asignado.")
		return
	
	var spawner = escenaSpawner.instantiate()
	
	# Posición adelante de la cámara.
	var pos = Vector2(
		camara.global_position.x,
		camara.global_position.y - offsetSpawn
	)
	
	spawner.global_position = pos
	spawner.camara = camara
	
	get_tree().current_scene.add_child(spawner)
	
	print("Spawner creado en: ", pos)
