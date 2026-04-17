extends CharacterBody2D

@export var margenBorrado: float = 100.0

# Variables generales del enemigo.
@export var velX: float = 200.0

var dir: float = 1

var jugador: Node2D
var camara: Camera2D

func _ready():
	$Nave.play("idle")
	jugador = get_tree().get_first_node_in_group("player")
	
	camara = get_viewport().get_camera_2d()

func _process(_delta):
	if camara == null:
		return
	
	var limiteAbajo = camara.global_position.y + get_viewport_rect().size.y
	
	if global_position.y > limiteAbajo + margenBorrado:
		queue_free()

func _physics_process(_delta):
	if camara == null:
		return
	
	var tamPantalla = get_viewport_rect().size
	var mitadPantalla = tamPantalla / 2
	
	var limIzq = camara.global_position.x - mitadPantalla.x - 50.0
	var limDer = camara.global_position.x + mitadPantalla.x - 150.0
	
	velocity.x = velX * dir
	
	# Rebote
	if global_position.x < limIzq:
		dir = 1
	elif global_position.x > limDer:
		dir = -1
	
	move_and_slide()
