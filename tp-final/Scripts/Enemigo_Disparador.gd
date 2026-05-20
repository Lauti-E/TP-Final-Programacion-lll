extends CharacterBody2D

@export var escenaExplosion: PackedScene
@export var escenaProyectil: PackedScene

# Variables generales del enemigo.
@export var velY: float = 10.0
@export var danColision: int = 10
@export var vidaMax: int = 50

var vidaActual: int
var jugador: Node2D

func _ready():
	$Nave.play("idle")
	jugador = get_tree().get_first_node_in_group("Player")
	
	vidaActual = vidaMax

func _physics_process(_delta):
	velocity = Vector2(0, velY)
	
	move_and_slide()
	
	var tamVentana = get_viewport_rect().size
	
	# Obtener tamaño del enemigo.
	var shape = $ColisionFisicas.shape
	var ancho = shape.get_rect().size / 2
	
	# Clamp con margen (para que no se genere en los bordes).
	global_position.x = clamp(global_position.x, ancho.x, tamVentana.x - ancho.x)
	
	if global_position.y > tamVentana.y + 50:
		queue_free()

func _on_area_deteccion_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("RecibirDan"):
			body.RecibirDan(danColision)
		queue_free()

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
	$Nave.modulate = Color(2,2,2)
	
	await  get_tree().create_timer(0.05).timeout
	
	$Nave.modulate = Color(1,1,1)


func _on_timer_disparo_timeout():
	var proyectil = escenaProyectil.instantiate()
	
	get_tree().current_scene.add_child(proyectil)
	
	proyectil.global_position = $"Punto Disparo".global_position
