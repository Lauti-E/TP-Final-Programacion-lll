extends Node2D

@export var velNivel: float = 0.0

var distancia: float = 0.0
var probDisparadorActual: int = 0

func _ready():
	add_to_group("GameManager")

func _process(delta):
	distancia += velNivel * delta
	print(int(distancia))
	
	if distancia >= 1000:
		probDisparadorActual = 30
	
