extends Area2D

var velProyectil: float
var danio: int

var direccion: Vector2 = Vector2.DOWN

func _process(delta):
	global_position += direccion * velProyectil * delta

	# Eliminar el proyectil al salir de la ventana.
	if global_position.y > 250:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.RecibirDan(danio)
		queue_free()


func ApuntarA(objetivo: Vector2):
	direccion = (objetivo - global_position).normalized()
