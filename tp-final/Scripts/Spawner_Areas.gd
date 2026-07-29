extends Node2D

var gameManager

@export var escenaArea: PackedScene

func _ready():
	gameManager = get_tree().get_first_node_in_group("GameManager")

	SpawnLoop()

func SpawnLoop():
	while true:

		if gameManager != null and !gameManager.eventoBossActivo:
			SpawnearArea()
		
		await get_tree().create_timer(randf_range(gameManager.tiempoAreaMin, gameManager.tiempoAreaMax)).timeout

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
