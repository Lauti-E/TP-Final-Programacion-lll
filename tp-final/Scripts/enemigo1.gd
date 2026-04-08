extends CharacterBody2D

@export var velocidad: float = 0

var jugador: Node2D

func _ready():
	jugador = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if jugador == null:
		return
		
	var dir = (jugador.global_position - global_position).normalized()
	
	velocity = dir * velocidad
	
	move_and_slide()
