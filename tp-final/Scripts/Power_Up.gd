extends Area2D

enum TipoPowerUp {
	VelocidadAtaque
}

@export var tipo: TipoPowerUp
@export var duracion: float = 0.0

@export var velCaida: float = 0.0

func _ready():
	add_to_group("PowerUp")

func _process(delta):
	position.y += velCaida * delta

	var altoPantalla = get_viewport_rect().size.y

	if global_position.y > altoPantalla:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.RecibirPowerUp(tipo, duracion)
		queue_free()