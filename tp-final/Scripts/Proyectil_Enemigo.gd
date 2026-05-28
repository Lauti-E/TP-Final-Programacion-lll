extends Area2D

@export var velProyectil: float = 0.0
@export var danio: int = 0

func _process(delta):
	position.y += velProyectil * delta
	
	# Eliminar el proyectil al salir de la ventana.
	if global_position.y > 250:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.RecibirDan(danio)
		queue_free()
