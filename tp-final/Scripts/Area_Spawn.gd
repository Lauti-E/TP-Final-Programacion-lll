extends Area2D

# Variables generales del área de spawn.
@export var velocidad: float = 0.0
@export var cantCarriles: int = 0

# Variables para los enemigos.
@export var escenaEnemigo: PackedScene
@export var escenaEnemigoDisparador: PackedScene
@export var cantEnemigos: int = 0

# Variables de spawn.
@export_range(0, 100) var probDisparador: int = 0

func _process(delta):
	position.y += velocidad * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		
		call_deferred("GenerarEnemigos")
		
		call_deferred("queue_free")

func GenerarEnemigos():
	if escenaEnemigo == null:
		return
	
	var tamVentana = get_viewport_rect().size
	
	var generarDisparador = randi_range(1, 100) <= probDisparador
	var indiceDisparador = randi() % cantEnemigos
	
	for i in cantEnemigos:
		# Obtener enemigo de su escena.
		var enemigo
		
		if generarDisparador and i == indiceDisparador:
			enemigo = escenaEnemigoDisparador.instantiate()
		else:
			enemigo = escenaEnemigo.instantiate()
		
		# Obtener el ancho de pantalla y del carril.
		var anchoPantalla = tamVentana.x
		var anchoCarril = anchoPantalla / cantCarriles
		
		# Crear la cantidad de carriles definidos.
		var carril = randi() % cantCarriles
		
		# Definir la posición de los spawns (X, Y).
		var spawnX = (carril * anchoCarril) + (anchoCarril / 2)
		var spawnY = -20
		
		# Generar al enemigo en esa posición.
		enemigo.global_position = Vector2(spawnX, spawnY)
		
		get_tree().current_scene.add_child(enemigo)
