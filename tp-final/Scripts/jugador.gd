extends CharacterBody2D

# Varibles del personaje.
@export var velocidad := 500.0

# Variables del proyectil.
@export var escenaProyectil: PackedScene
@export var cadenciaDisparo: float = 0.2

# Variables de disparo.
var puedeDisparar: bool = true

func _process(_delta):
	if Input.is_action_pressed("disparar") and puedeDisparar:
		Disparar()

func _ready():
	$Personaje.play("idle")

func _physics_process(_delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	velocity = dir * velocidad
	
	move_and_slide()
	
	# Limitar el movimiento del personaje dentro de la cámara.
	var camara = $Camera2D
	
	var izq = camara.limit_left
	var der = camara.limit_right
	var arriba = camara.limit_top
	var abajo = camara.limit_bottom
	
	# Tomamos el tamaño desde la colisión.
	var shape = $CollisionShape2D.shape
	var extents = shape.get_rect().size / 2
	
	global_position.x = clamp(global_position.x, izq + extents.x + 25, der - extents.x - 25)
	global_position.y = clamp(global_position.y, arriba + extents.y - 25, abajo - extents.y - 25)

func Disparar():
	puedeDisparar = false
	
	var proyectil = escenaProyectil.instantiate()
	
	proyectil.global_position = $"Punto Proyectil Der".global_position
	
	get_tree().current_scene.add_child(proyectil)
	
	await get_tree().create_timer(cadenciaDisparo).timeout
	
	puedeDisparar = true
