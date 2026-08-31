extends Node2D

@export var escenaPowerUp: PackedScene
var gameManager

# Variables relacionadas a la generación de los PowerUp.
@export var tiempoEntreIntentos: float = 0.0
@export var distanciaMinEnemigo: float = 0.0

func _ready():
	gameManager = get_tree().get_first_node_in_group("GameManager")
	while true:
		await get_tree().create_timer(tiempoEntreIntentos).timeout

		IntentarGenerarPowerUp()

func IntentarGenerarPowerUp():
	if escenaPowerUp == null:
		return

	if get_tree().get_nodes_in_group("PowerUp").size() > 0:
		return

	if randf() < gameManager.probPowerUpActual:
			var anchoVentana = get_viewport_rect().size.x
			var margen = 20
			
			var randomX = randf_range(margen, anchoVentana - margen)
			var posPowerUp = Vector2(randomX, -20)

			if DetectarEnemigo(posPowerUp):
				return

			var powerUp = escenaPowerUp.instantiate()
			powerUp.global_position = posPowerUp
			get_tree().current_scene.add_child(powerUp)
			print("Generar PowerUp")

func DetectarEnemigo(posicion: Vector2):
	for enemigo in get_tree().get_nodes_in_group("Enemigo"):
		var distancia = enemigo.global_position.distance_to(posicion)

		if distancia < distanciaMinEnemigo:
			print(distancia)
			return true
	return false