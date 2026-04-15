extends CharacterBody2D

# Referencia a la cámara.
@export var camara: Camera2D

@export var margenBorrado: float = 100
@export var velocidad: float = 0

var jugador: Node2D

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
	
	move_and_slide()
