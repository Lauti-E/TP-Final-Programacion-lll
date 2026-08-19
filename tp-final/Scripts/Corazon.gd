extends Area2D

@export var cantCuracion: int = 0
@export var velCaida: float = 0.0

func _process(delta):
	position.y += velCaida * delta

	var altoPantalla = get_viewport_rect().size.y

	if global_position.y > altoPantalla:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.RecuperarVida(cantCuracion)
		queue_free()