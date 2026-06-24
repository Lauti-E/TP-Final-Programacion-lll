extends CharacterBody2D

@export var velEntrada: float = 0.0
@export var velLateral: float = 0.0

@export var posCombateY: float = 0.0

var entrando: bool = true
var dir: int = 1

func _ready():
	$Boss1.play("idle")

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
