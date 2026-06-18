extends Node2D

@export var velNivel: float = 0.0

# Variables para generar enemigos/obstáculos, etc.
var distancia: float = 0.0
var probDisparadorActual: int = 0

var generarAsteroide: bool = false
var tiempoAsteroideMin: float = 5.0
var tiempoAsteroideMax: float = 10.0

func _ready():
	add_to_group("GameManager")

func _process(delta):
	distancia += velNivel * delta
	
	print(distancia)
	
	if distancia >= 1000: generarAsteroide = true
	if distancia >= 3000:
		tiempoAsteroideMin = 4.0
		tiempoAsteroideMax = 8.0
	if distancia >= 5000:
		tiempoAsteroideMin = 3.0
		tiempoAsteroideMax = 6.0
	if distancia >= 7000:
		tiempoAsteroideMin = 2.0
		tiempoAsteroideMax = 4.0
	
	if distancia >= 3000:
		probDisparadorActual = 30
	if distancia >= 4000:
		probDisparadorActual = 50
	if distancia >= 5000:
		probDisparadorActual = 70
	
