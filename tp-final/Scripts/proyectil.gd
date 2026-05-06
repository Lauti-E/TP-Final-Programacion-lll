extends Area2D

@export var velProyectil: float = 500
@export var danio: int = 20

func _process(delta):
	position.y -= velProyectil * delta
	
	# Eliminar el proyectil al salir de la ventana.
	if global_position.y < -50:
		queue_free()

func _on_body_entered(body):
	if body.has_method("RecibirDanio"):
		body.RecibirDanio(danio)
		queue_free()
	
