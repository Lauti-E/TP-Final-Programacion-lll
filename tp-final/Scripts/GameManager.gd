extends Node2D

@export var velNivel: float = 50.0

var distancia: float = 0.0

func _process(delta):
	distancia += velNivel * delta
	print(int(distancia))
