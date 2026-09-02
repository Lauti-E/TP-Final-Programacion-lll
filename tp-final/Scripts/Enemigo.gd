extends CharacterBody2D
class_name Enemigo

@export var escenaExplosion: PackedScene

# Variables generales del enemigo.
@export var velY: float = 0.0
@export var distanciaReduccionVelY: float = 0.0
@export var velYFinal: float = 0.0
@export var danColision: int = 0
@export var danFueraVen: int = 0
@export var vidaMax: int = 0

@onready var feedbackEnemigo

# Variables de energía.
@export var energiaOtorgada: int = 0

var vidaActual: int
var jugador: Node2D
var carril

func _ready():
	jugador = get_tree().get_first_node_in_group("Player")
	feedbackEnemigo = get_tree().get_first_node_in_group("FeedbackEnemigo")
	add_to_group("Enemigo")
	
	vidaActual = vidaMax

func _physics_process(_delta):
	var tamVentana = get_viewport_rect().size

	if global_position.y > tamVentana.y - distanciaReduccionVelY:
		velocity = Vector2(0, velYFinal)
	else:
		velocity = Vector2(0, velY)
	
	move_and_slide()
	
	
	# Obtener tamaño del enemigo.
	var shape = $ColisionFisicas.shape
	var ancho = shape.get_rect().size / 2
	
	# Clamp con margen (para que no se genere en los bordes).
	global_position.x = clamp(global_position.x, ancho.x, tamVentana.x - ancho.x)
	
	if global_position.y > tamVentana.y + 10 && jugador != null:
		jugador.RecibirDan(danFueraVen)

		feedbackEnemigo.ActualizarBarra(carril)
		queue_free()

	if global_position.y > tamVentana.y - 150:
		feedbackEnemigo.ActualizarBarra(carril)
		
func _on_area_deteccion_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("RecibirDan"):
			body.RecibirDan(danColision)
		
		feedbackEnemigo.ActualizarBarra(carril)
		queue_free()

func RecibirDanio(cantidad: int, daEnergia: bool = true):
	vidaActual -= cantidad
	
	HitFlash()
	
	if vidaActual <= 0:
		Morir(daEnergia)

func Morir(daEnergia: bool = true):
	if escenaExplosion != null:
		var explosion = escenaExplosion.instantiate()
		
		explosion.global_position = global_position
		
		get_tree().current_scene.add_child(explosion)
	
	# Buscar al jugador.
	jugador = get_tree().get_first_node_in_group("Player")
	
	if daEnergia:
		if jugador and jugador.has_method("GanarEnergia"):
			jugador.GanarEnergia(energiaOtorgada)
	
	feedbackEnemigo.ActualizarBarra(carril)
	queue_free()

func HitFlash():
	FlashLoop()

func FlashLoop():
	$Nave.modulate = Color(2,2,2)
	
	await  get_tree().create_timer(0.05).timeout
	
	$Nave.modulate = Color(1,1,1)
