extends Node2D

@export var velNivel: float = 0.0

# Variables para generar enemigos/obstáculos, etc.
var distancia: float = 0.0
var probDisparadorActual: int = 0
var generarAsteroide: bool = false

func _ready():
	add_to_group("GameManager")

func _process(delta):
	distancia += velNivel * delta
	
	if distancia >= 1000: generarAsteroide = true
	
	if distancia >= 3000:
		probDisparadorActual = 30
	
