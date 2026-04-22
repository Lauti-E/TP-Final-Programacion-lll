extends Area2D

@export var velocidad: float = 20.0

func _process(delta):
	position.y += velocidad * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Jugador Detectado")
