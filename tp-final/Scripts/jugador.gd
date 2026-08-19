extends CharacterBody2D

# Referencias y variables para los Power-Ups.
const Power_Up = preload("res://Scripts/Power_Up.gd")
@onready var textoPowerUp = $"../UI/TiempoPowerUp"
var duracionPowerUp: float
var tiempoRestante: float

# LLamada a la barra de vida y energía.
@onready var barraVida = $"../UI/BarraVida"
@onready var barraEnergia = $"../UI/BarraEnergia"

# Varibles de velocidad.
@export var velocidad := 0.0
@export var aceleracion: float = 0.0
@export var desaceleracion: float = 0.0

# Sistema de vida.
@export var vidaMax: int = 0
@export var tiempoInvulnerable: float = 0

var vidaActual: int
var invulnerable: bool = false

# Sistema de energía.
@export var energiaMax: int = 0
var energiaActual: int = 0

# Onda expansiva.
@export var escenaOnda: PackedScene

# Variables de los proyectiles.
@export var escenaProyectil: PackedScene
@export var cadenciaDisparo: float = 0.0
var cadenciaBase: float

@export var escenaProyectilOnda: PackedScene

# Variables para la sombra del dash.
@export var escenaSombra: PackedScene
@export var tiempoEntreSombras: float = 0.0

# Variables del dash.
@export var velDash: float = 0.0
@export var durDash: float = 0.0
@export var cooldownDash: float = 0

var puedeDashear: bool = true
var estaDasheando: bool = false

# Variables para el empuje.
@export var desaceleracionEmpuje: float = 0.0
var empuje := Vector2.ZERO

# Efecto de parpadeo para el cooldown del dash.
@export var tiempoParpadeo: float = 0.0

# Variables generales.
var aturdido: bool = false
var ultimaDir:= Vector2.ZERO

# Variables de disparo.
var puedeDisparar: bool = true

func _ready():
	$Personaje.play("idle")
	add_to_group("Player")
	
	# Asignar las variables de vida.
	vidaActual = vidaMax
	barraVida.max_value = vidaMax
	barraVida.value = vidaActual
	
	# Asiganr las variables de energía.
	barraEnergia.max_value = energiaMax
	barraEnergia.value = energiaActual

	cadenciaBase = cadenciaDisparo

func _process(delta):
	if aturdido:
		return
	
	if tiempoRestante > 0:
		tiempoRestante = tiempoRestante - delta
		textoPowerUp.text = "PowerUp: " + str(snapped(tiempoRestante, 0.1))
		textoPowerUp.visible = true
	else:
		textoPowerUp.visible = false

	if Input.is_action_pressed("disparar") and puedeDisparar:
		Disparar()
	
	if Input.is_action_just_pressed("proyectil_onda") and energiaActual >= energiaMax:
		DispararOnda()
	
	if Input.is_action_just_pressed("ui_accept") and energiaActual >= energiaMax:
		CrearOnda()

func _physics_process(_delta):
	if aturdido:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if dir != Vector2.ZERO:
		ultimaDir = dir
	
	if Input.is_action_just_pressed("dash") and puedeDashear:
		Dash()
	
	if estaDasheando:
		velocity = ultimaDir * velDash
	else:
		var objetivo = dir * velocidad
		
		if dir != Vector2.ZERO:
			velocity = velocity.move_toward(objetivo, aceleracion * _delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, desaceleracion * _delta)
	
	velocity += empuje

	empuje = empuje.move_toward(Vector2.ZERO, desaceleracionEmpuje * _delta)

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

func DispararOnda():
	if escenaProyectilOnda == null:
		return

	if energiaActual < energiaMax:
		return
	
	var proyectilOnda = escenaProyectilOnda.instantiate()

	proyectilOnda.global_position = $"Punto Proyectil".global_position

	get_tree().current_scene.add_child(proyectilOnda)

	energiaActual = 0
	barraEnergia.value = energiaActual
	
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

func Aturdir(tiempo: float):
	if aturdido:
		return
	
	aturdido = true
	
	await get_tree().create_timer(tiempo).timeout
	
	aturdido = false

func Empujar(direccion: Vector2, fuerza: float):
	empuje = direccion * fuerza

func GanarEnergia(cantidad:int):
	energiaActual += cantidad
	energiaActual = min(energiaActual, energiaMax)
	
	barraEnergia.value = energiaActual

func CrearOnda():
	if escenaOnda == null:
		return
	
	if energiaActual < energiaMax:
		return
	
	var onda = escenaOnda.instantiate()
	onda.global_position = global_position
	
	get_tree().current_scene.add_child(onda)
	
	energiaActual = 0
	barraEnergia.value = energiaActual

func RecibirPowerUp(tipo, duracion):
	match tipo:
		Power_Up.TipoPowerUp.VelocidadAtaque:
			cadenciaDisparo *= 0.7
			duracionPowerUp = duracion
			tiempoRestante = duracion
			await get_tree().create_timer(duracion).timeout
			cadenciaDisparo = cadenciaBase

func RecuperarVida(cantidad: int):
	vidaActual += cantidad
	vidaActual = min(vidaActual, vidaMax)

	barraVida.value = vidaActual