extends Node2D

@export var escenaCorazon: PackedScene
var gameManager

# Variables generales relacionadas a la generación de los corazones.
@export var tiempoEntreIntentos: float = 0.0
@export var probGenerarCorazon: float = 0.0
@export var distanciaMinEnemigo: float = 0.0

func _ready():
	gameManager = get_tree().get_first_node_in_group("GameManager")
	while true:
		await get_tree().create_timer(tiempoEntreIntentos).timeout

		IntentarGenerarCorazon()

func IntentarGenerarCorazon():
	if escenaCorazon == null:
		return

	if get_tree().get_nodes_in_group("Corazon").size() >= 2:
		return
	
	if gameManager.distancia < 2000:
		return

	if randf() < probGenerarCorazon:
		var anchoVentana = get_viewport_rect().size.x
		var margen = 20

		var randomX = randf_range(margen, anchoVentana - margen)
		var posCorazon = Vector2(randomX, -20)

		if DetectarEnemigo(posCorazon):
			return

		var corazon = escenaCorazon.instantiate()
		corazon.global_position = posCorazon
		get_tree().current_scene.add_child(corazon)
		print("Generar Corazon")

func DetectarEnemigo(posicion: Vector2):
	for enemigo in get_tree().get_nodes_in_group("Enemigo"):
		var distancia = enemigo.global_position.distance_to(posicion)

		if distancia < distanciaMinEnemigo:
			print(distancia)
			return true
	return false