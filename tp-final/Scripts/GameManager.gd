extends Node2D

@export var velNivel: float = 0.0

var distancia: float = 0.0
var probDisparadorActual: int = 0

func _ready():
	add_to_group("GameManager")

func _process(delta):
	distancia += velNivel * delta
	
	if distancia >= 2000:
		probDisparadorActual = 30
	
