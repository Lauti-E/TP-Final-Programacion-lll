extends Node2D

@export var escenaCorazon: PackedScene

@export var tiempoEntreIntentos: float = 0.0
@export var probGenerarCorazon: float = 0.0
@export var distanciaMinEnemigo: float = 0.0

func _ready():
	while true:
		await get_tree().create_timer(tiempoEntreIntentos).timeout

		IntentarGenerarCorazon()

func IntentarGenerarCorazon():
	if escenaCorazon == null:
		return

	if get_tree().get_nodes_in_group("Corazon").size() >= 2:
		return

	if randf() < probGenerarCorazon:
		var anchoVentana = get_viewport_rect().size.x
		var margen = 20

		var randomX = randf_range(margen, anchoVentana - margen)
		var posCorazon = Vector2(randomX, -20)

		if DetectarEnemigo(randomX):
			return

		var corazon = escenaCorazon.instantiate()
		corazon.global_position = posCorazon
		get_tree().current_scene.add_child(corazon)
		print("Generar Corazon")

func DetectarEnemigo(posicion: float):
	for enemigo in get_tree().get_nodes_in_group("Enemigo"):
		var distanciaX = abs(enemigo.global_position.x - posicion)

		if distanciaX < distanciaMinEnemigo:
			print(distanciaX)
			return true
	return false