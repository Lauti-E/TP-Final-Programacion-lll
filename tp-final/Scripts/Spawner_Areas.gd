extends Node2D

@export var escenaArea: PackedScene

@export var tiempoMin: float = 3.0
@export var tiempoMax: float = 10.0

func _ready():
	SpawnLoop()

func SpawnLoop():
	while true:
		SpawnearArea()
		
		await get_tree().create_timer(randf_range(tiempoMin, tiempoMax)).timeout

func SpawnearArea():
	if escenaArea == null:
		return
	
	var area = escenaArea.instantiate()
	
	# Posición arriba de la pantalla.
	var tamVentana = get_viewport_rect().size
	
	# Posición centrada en X.
	
	var spawnX = tamVentana.x / 2
	var spawnY = -50
	
	area.global_position = Vector2(spawnX, spawnY)
	
	# Ajustar el tamaño del área.
	var shape = area.get_node("CollisionShape2D").shape
	
	shape.size.x = tamVentana.x
	shape.size.y = 20
	
	get_tree().current_scene.add_child.call_deferred(area)
