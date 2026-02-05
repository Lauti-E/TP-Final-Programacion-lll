extends Area2D

@export var velProyectil: float = 500

func _process(delta):
	position.y -= velProyectil * delta
