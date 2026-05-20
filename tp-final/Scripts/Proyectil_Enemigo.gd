extends Area2D

@export var velProyectil: float = 80.0
@export var danio: int = 20

func _process(delta):
	position.y += velProyectil * delta
	
	# Eliminar el proyectil al salir de la ventana.
	if global_position.y > 250:
		queue_free()
