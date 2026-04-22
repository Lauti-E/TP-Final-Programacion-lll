extends CharacterBody2D

# Variables generales del enemigo.
@export var velY: float = 20.0
@export var danColision: int = 20

var jugador: Node2D

func _ready():
	$Nave.play("idle")
	jugador = get_tree().get_first_node_in_group("Player")

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
