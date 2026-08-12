extends Node2D

@export var escenaPowerUp: PackedScene
var gameManager

# Tiempo entre intentos de generar un PowerUp.
@export var tiempoEntreIntentos: float = 0.0

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
			var powerUp = escenaPowerUp.instantiate()
			var anchoVentana = get_viewport_rect().size.x
			var margen = 20
			
			var randomX = randf_range(margen, anchoVentana - margen)
			powerUp.global_position = Vector2(randomX, -20)

			get_tree().current_scene.add_child(powerUp)
			print("Generar PowerUp")
