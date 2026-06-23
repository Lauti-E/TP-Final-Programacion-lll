extends Node2D

@export var velNivel: float = 0.0

# Variables para generar enemigos/obstáculos, etc.
var distancia: float = 9000.0
var probDisparadorActual: int = 0

var generarAsteroide: bool = false
var tiempoAsteroideMin: float = 5.0
var tiempoAsteroideMax: float = 10.0

# Variables relacionadas al boss.
@export var escenaBoss: PackedScene

var eventoBossActivo: bool = false
var bossGenerado: bool = false

func _ready():
	add_to_group("GameManager")

func _process(delta):
	# Aumentar la distancia del nivel constantemente.
	if distancia <= 10000:
		distancia += velNivel * delta
	
	print(int(distancia))
	
	# Según la distancia, ajustar la probabilidad de generar disparadores y asteroides.
	if distancia >= 500: generarAsteroide = true
	if distancia >= 2000:
		tiempoAsteroideMin = 4.0
		tiempoAsteroideMax = 8.0
	if distancia >= 4000:
		tiempoAsteroideMin = 3.0
		tiempoAsteroideMax = 6.0
	if distancia >= 6000:
		tiempoAsteroideMin = 2.0
		tiempoAsteroideMax = 4.0
	
	if distancia >= 3000:
		probDisparadorActual = 30
	if distancia >= 4000:
		probDisparadorActual = 50
	if distancia >= 5000:
		probDisparadorActual = 70
	
	# Activar el evento del boss cuando se alcance cierta distancia.
	if distancia >= 10000 and !eventoBossActivo:
		eventoBossActivo = true
		GenerarBoss()

func GenerarBoss():
	if bossGenerado:
		return
	
	var boss = escenaBoss.instantiate()
	var tamVentana = get_viewport_rect().size

	boss.global_position = Vector2(tamVentana.x / 2, 100)

	get_tree().current_scene.add_child(boss)

	bossGenerado = true

	
