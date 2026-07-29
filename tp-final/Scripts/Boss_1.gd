extends CharacterBody2D

# Referencia a las escenas.
@export var escenaExplosion: PackedScene
@export var escenaProyectil: PackedScene

# Referencia al jugador.
var jugador: Node2D

# Llamada a la barra de vida.
@onready var barraBoss = $"../UI/BarraBoss"

# Variables para la vida del boss.
@export var vidaMax: int = 0
var vidaActual: int

# Variables para la velocidad del boss.
@export var velEntrada: float = 0.0
@export var velLateral: float = 0.0

# Posición en combate después de la presentación.
@export var posCombateY: float = 0.0

# Variables relacionadas a los poderes/habilidades y disparos del boss.
@export var tiempoDisparos: float = 0.0
@export var cantidadDisparos: int = 0
@export var velocidadProyectil: float = 0.0
@export var danioProyectil: int = 0

# Variables relacionadas con la Fase 2 del boss.
var fase2: bool = false
@export var multiVel: float = 0.0
@export var multiProy: float = 0.0
@export var multiCad: float = 0.0

var ataques = []

# Variables generales.
var entrando: bool = true
var dir: int = 1
@export var danColision: int = 0
@export var fuerzaEmpuje: float = 0.0

# Variables para el cambio repentino de dirección.
@export_range(0, 100) var probCambioDir := 40
var cambio := false

func _ready():
	$Boss1.play("idle")

	add_to_group("Enemigo")

	# Asignar las variables de vida.
	vidaActual = vidaMax
	barraBoss.max_value = vidaMax
	barraBoss.value = vidaActual

	jugador = get_tree().get_first_node_in_group("Player")

	ataques.append(Callable(self, "Disparar"))
	ataques.append(Callable(self, "Rafaga"))


func _physics_process(_delta):
	if entrando:
		velocity = Vector2(0, velEntrada)

		if global_position.y >= posCombateY:
			velocity = Vector2.ZERO

			entrando = false
			barraBoss.visible = true

			$"Timer Disparo".start()
	else:
		# Movimiento lateral.
		velocity.x = velLateral * dir
		velocity.y = 0

		# Tamaño de la ventana.
		var tamVentana = get_viewport_rect().size
		var centro = tamVentana.x / 2

		if global_position.x <= 30:
			dir = 1
		elif global_position.x >= tamVentana.x -30:
			dir = -1

		# Probabilidad de cambiar de dirección al pasar por el centro.
		if abs(global_position.x - centro) < 20 and !cambio:
			if randi_range(1, 100) <= probCambioDir:
				dir *= -1
			
			cambio = true

		if abs(global_position.x - centro) > 40:
			cambio = false

	move_and_slide()

func RecibirDanio(cantidad: int):
	if entrando:
		return

	vidaActual -= cantidad
	barraBoss.value = vidaActual

	HitFlash()

	if vidaActual <= (vidaMax / 2) and !fase2:
		Fase2()

	if vidaActual <= 0:
		barraBoss.visible = false
		Morir()

func Morir():
	if escenaExplosion != null:
		var explosion = escenaExplosion.instantiate()

		explosion.global_position = global_position

		get_tree().current_scene.add_child(explosion)
	
	queue_free()

func HitFlash():
	FlashLoop()

func FlashLoop():
	$Boss1.modulate = Color(2,2,2)
	
	await get_tree().create_timer(0.05).timeout
	
	$Boss1.modulate = Color(1,1,1)

func Disparar():
	var proyectil = escenaProyectil.instantiate()

	proyectil.velProyectil = velocidadProyectil
	proyectil.danio = danioProyectil

	get_tree().current_scene.add_child(proyectil)

	proyectil.global_position = $"Punto Disparo".global_position

	if jugador != null:
		proyectil.ApuntarA(jugador.global_position)

func Rafaga():
	for i in cantidadDisparos:
		Disparar()
		if i != cantidadDisparos - 1:
			await get_tree().create_timer(tiempoDisparos).timeout

func ElegirAtaque():
	var indice = randi_range(0, ataques.size() - 1)

	ataques[indice].call()

	if ataques.is_empty():
		return

func _on_timer_disparo_timeout():
	ElegirAtaque()

func _on_area_deteccion_body_entered(body):
	if body.is_in_group("Player"):
		var direccion = (body.global_position - global_position).normalized()
		
		body.Empujar(direccion, fuerzaEmpuje)

func Fase2():
	fase2 = true

	velLateral *= multiVel
	velocidadProyectil *= multiProy

	$"Timer Disparo".wait_time *= multiCad
	
