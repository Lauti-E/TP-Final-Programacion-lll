extends CharacterBody2D

# LLamada a la barra de vida.
@onready var barraVida = $"../UI/BarraVida"

# Varibles del personaje.
@export var velocidad := 0.0

# Sistema de vida.
@export var vidaMax: int = 0
@export var tiempoInvulnerable: float = 0

var vidaActual: int
var invulnerable: bool = false

# Variables del proyectil.
@export var escenaProyectil: PackedScene
@export var cadenciaDisparo: float = 0.0

# Variables para la sombra del dash.
@export var escenaSombra: PackedScene
@export var tiempoEntreSombras: float = 0.0

# Variables del dash.
@export var velDash: float = 0.0
@export var durDash: float = 0.0
@export var cooldownDash: float = 0

# Efecto de parpadeo para el cooldown del dash.
@export var tiempoParpadeo: float = 0.0

var puedeDashear: bool = true
var estaDasheando: bool = false
var ultimaDir:= Vector2.ZERO

# Variables de disparo.
var puedeDisparar: bool = true

func _ready():
	$Personaje.play("idle")
	add_to_group("Player")
	
	vidaActual = vidaMax
	barraVida.max_value = vidaMax
	barraVida.value = vidaActual

func _process(_delta):
	if Input.is_action_pressed("disparar") and puedeDisparar:
		Disparar()
	
	if Input.is_action_just_pressed("ui_accept"):
		RecibirDan(10)

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
	
	var tamVentana = get_viewport_rect().size
	
	var shape = $CollisionShape2D.shape
	var long = shape.get_rect().size / 2
	
	global_position.x = clamp(global_position.x, long.x, tamVentana.x - long.x)
	
	global_position.y = clamp(global_position.y, long.y, tamVentana.y - long.y)

func Disparar():
	puedeDisparar = false
	
	var proyectil = escenaProyectil.instantiate()
	
	proyectil.global_position = $"Punto Proyectil".global_position
	
	get_tree().current_scene.add_child(proyectil)
	
	await get_tree().create_timer(cadenciaDisparo).timeout
	
	puedeDisparar = true

func RecibirDan(cantidad: int):
	if invulnerable or estaDasheando:
		return
	
	vidaActual -= cantidad
	print("Vida: ", vidaActual)
	barraVida.value = vidaActual
	
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
	$CollisionShape2D.set_deferred("disabled", true)
	
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
	
	$CollisionShape2D.disabled = true
	
	GenerarSombra()
	
	await get_tree().create_timer(durDash).timeout
	
	estaDasheando = false
	
	$CollisionShape2D.disabled = false
	
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
	sombra.scale = spritePersonaje.scale * 0.15
	
	# Color.
	sombra.modulate = Color(1, 1, 1, 0.6)
	
	get_tree().current_scene.add_child(sombra)
	
	await get_tree().create_timer(tiempoEntreSombras).timeout
	
	SombraLoop()
