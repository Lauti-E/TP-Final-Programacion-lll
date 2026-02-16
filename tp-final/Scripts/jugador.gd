extends CharacterBody2D

# Varibles de la nave.
@export var velocidad := 500.0

# Variables del proyectil.
@export var escenaProyectil: PackedScene
@export var cadenciaDisparo: float = 0.5

var puedeDisparar: bool = true
var disparoIzq: bool = true # Variable para alternar el disparo.

func _process(delta):
	if Input.is_action_pressed("disparar") and puedeDisparar:
		Disparar()

func Disparar():
	puedeDisparar = false
	
	var proyectil = escenaProyectil.instantiate()
	
	# Elegir punto a disparar.
	if disparoIzq:
		proyectil.global_position = $"Punto Proyectil Izq".global_position
	else:
		proyectil.global_position = $"Punto Proyectil Der".global_position
	
	# Alternar para el próximo disparo.
	disparoIzq = !disparoIzq
	
	get_tree().current_scene.add_child(proyectil)
	
	await get_tree().create_timer(cadenciaDisparo).timeout
	
	puedeDisparar = true

func _physics_process(_delta):
	# Movimiento de la nave.
	var dir := Vector2.ZERO
	
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		
	velocity = dir * velocidad
	
	move_and_slide()
	
	# Limitar el movimiento de la nave dentro de la cámara.
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
