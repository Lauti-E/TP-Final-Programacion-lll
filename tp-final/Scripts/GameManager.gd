extends Node2D

@export var velNivel: float = 0.0

# Variables para generar enemigos/obstáculos, etc.
@export var distancia: float = 0.0
var probDisparadorActual: int = 0

# Variables para controlar la generación de los asteroides.
var generarAsteroide: bool = false
var tiempoAsteroideMin: float = 5.0
var tiempoAsteroideMax: float = 10.0

# Variables para controlar la generación de las areas de spawn.
var tiempoAreaMin: float = 4.0
var tiempoAreaMax: float = 10.0

# Variables relacionadas al boss.
@export var escenaBoss: PackedScene

# Condiciones del boss.
var eventoBossActivo: bool = false
var bossGenerado: bool = false

func _ready():
	add_to_group("GameManager")

func _process(delta):
	# Aumentar la distancia del nivel constantemente.
	if distancia <= 10000:
		distancia += velNivel * delta
	
	print(distancia)
	
	# Según la distancia, ajustar la probabilidad de generar disparadores y asteroides.
	if distancia >= 1000: generarAsteroide = true

	if distancia >= 2000:
		tiempoAsteroideMin = 4.0
		tiempoAsteroideMax = 8.0

		tiempoAreaMin = 4.0
		tiempoAreaMax = 8.0
	if distancia >= 4000:
		tiempoAsteroideMin = 3.0
		tiempoAsteroideMax = 6.0

		tiempoAreaMin = 4.0
		tiempoAreaMax = 6.0
	if distancia >= 6000:
		tiempoAsteroideMin = 3.0
		tiempoAsteroideMax = 6.0
	
	if distancia >= 2000:
		probDisparadorActual = 40
	if distancia >= 4000:
		probDisparadorActual = 50
	if distancia >= 6000:
		probDisparadorActual = 60
	
	# Activar el evento del boss cuando se alcance cierta distancia.
	if distancia >= 10000 and !eventoBossActivo:
		eventoBossActivo = true
		GenerarBoss()

func GenerarBoss():
	if bossGenerado:
		return
	
	var boss = escenaBoss.instantiate()
	var tamVentana = get_viewport_rect().size

	boss.global_position = Vector2(tamVentana.x / 2, -100)

	get_tree().current_scene.add_child(boss)

	bossGenerado = true

	
