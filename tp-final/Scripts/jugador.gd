extends CharacterBody2D

# Varibles del personaje.
@export var velocidad := 300.0

# Sistema de vida.
@export var vidaMax: int = 100
@export var tiempoInvulnerable: float = 2

var vidaActual: int
var invulnerable: bool = false

# Variables del proyectil.
@export var escenaProyectil: PackedScene
@export var cadenciaDisparo: float = 0.2

# Variables para la sombra del dash.
@export var escenaSombra: PackedScene
@export var tiempoEntreSombras: float = 0.05

# Variables del dash.
@export var velDash: float = 1200.0
@export var durDash: float = 0.15
@export var cooldownDash: float = 1

# Efecto de parpadeo para el cooldown del dash.
@export var tiempoParpadeo: float = 0.2

var puedeDashear: bool = true
var estaDasheando: bool = false
var ultimaDir:= Vector2.ZERO

# Variables de disparo.
var puedeDisparar: bool = true

func _process(_delta):
	if Input.is_action_pressed("disparar") and puedeDisparar:
		Disparar()
	
	if Input.is_action_just_pressed("ui_accept"):
		RecibirDan(10)

func _ready():
	$Personaje.play("idle")
	
	vidaActual = vidaMax

func _physics_process(_delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if dir != Vector2.ZERO:
		ultimaDir = dir
	
	if Input.is_action_just_pressed("dash") and puedeDashear:
		Dash()
	
	if estaDasheando:
		velocity = ultimaDir * velDash
	else:
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

func RecibirDan(cantidad: int):
	if invulnerable:
		return
	
	vidaActual -= cantidad
	print("Vida: ", vidaActual)
	
	# Activar invulneravilidad.
	invulnerable = true
	
	# Feedback visual del daño.
	ParpadeoDan()
	
	if vidaActual <= 0:
		Morir()
	
	await get_tree().create_timer(tiempoInvulnerable).timeout
	
	invulnerable = false
	

func Morir():
	print("Jugador muerto.")
	
	# Desactivar acciones.
	set_physics_process(false)
	set_process(false)
	
	# Desactivar colisiones (Por las dudas).
	$CollisionShape2D.disabled = true
	
	# Fade out para desaparecer poco a poco.
	var tween = create_tween()
	tween.tween_property($Personaje, "modulate:a", 0.0, 0.5)
	
	await  tween.finished
	
	queue_free()

func ParpadeoDan():
	ParpadeoLoop()

func ParpadeoLoop():
	if !invulnerable:
		$Personaje.modulate = Color(1,1,1)
		return
	
	# Alternar entre rojo y normal.
	if $Personaje.modulate == Color(1,1,1):
		$Personaje.modulate = Color(2, 0.3, 0.3) # Color Rojo.
	else:
		$Personaje.modulate = Color(1,1,1)
	
	await get_tree().create_timer(0.2).timeout
	
	ParpadeoLoop()

func Dash():
	puedeDashear = false
	estaDasheando = true
	
	GenerarSombra()
	
	await get_tree().create_timer(durDash).timeout
	
	estaDasheando = false
	
	# Iniciar parpadeo del cooldown.
	CooldownParpadeo()
	
	await get_tree().create_timer(cooldownDash).timeout
	
	# Volver el personaje a su color normal.
	$Personaje.modulate.a = 1.0
	
	puedeDashear = true

func CooldownParpadeo():
	LoopParpadear()

func LoopParpadear():
	if puedeDashear:
		$Personaje.modulate = Color(1,1,1	) # Color normal.
		return
		
	# Alternar entre blanco y normal.
	if $Personaje.modulate == Color(1,1,1):
		$Personaje.modulate = Color(2,2,2) # Color blanco.
	else:
		$Personaje.modulate = Color(1,1,1)
	
	await get_tree().create_timer(tiempoParpadeo).timeout
	
	LoopParpadear()

func GenerarSombra():
	SombraLoop()

func SombraLoop():
	if !estaDasheando:
		return
	
	if escenaSombra == null:
		return
	
	var sombra = escenaSombra.instantiate() 
	
	var spritePersonaje = $Personaje
	
	# Copiar la apariencia.
	sombra.texture = spritePersonaje.sprite_frames.get_frame_texture(
		spritePersonaje.animation,
		spritePersonaje.frame
	)
	
	sombra.global_position = $Personaje.global_position
	sombra.rotation = $Personaje.global_rotation
	sombra.scale = spritePersonaje.scale * 0.5
	
	# Color.
	sombra.modulate = Color(1, 1, 1, 0.6)
	
	get_tree().current_scene.add_child(sombra)
	
	await get_tree().create_timer(tiempoEntreSombras).timeout
	
	SombraLoop()
