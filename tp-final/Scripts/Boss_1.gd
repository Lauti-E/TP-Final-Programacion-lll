extends CharacterBody2D

@export var escenaExplosion: PackedScene

@export var vidaMax: int = 0
var vidaActual: int

@export var velEntrada: float = 0.0
@export var velLateral: float = 0.0

@export var posCombateY: float = 0.0

@export var danColision: int = 0

var entrando: bool = true
var dir: int = 1

func _ready():
	$Boss1.play("idle")

	add_to_group("Enemigo")

	vidaActual = vidaMax

func _physics_process(delta):
	if entrando:
		velocity = Vector2(0, velEntrada)

		if global_position.y >= posCombateY:
			velocity = Vector2.ZERO

			entrando = false
	else:
		# Movimiento lateral.
		velocity.x = velLateral * dir
		velocity.y = 0

		# Tamaño de la ventana.
		var tamVentana = get_viewport_rect().size

		if global_position.x <= 50:
			dir = 1
		elif global_position.x >= tamVentana.x -50:
			dir = -1

			
	move_and_slide()

func RecibirDanio(cantidad: int):
	vidaActual -= cantidad

	HitFlash()

	if vidaActual <= 0:
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
	
	await  get_tree().create_timer(0.05).timeout
	
	$Boss1.modulate = Color(1,1,1)
