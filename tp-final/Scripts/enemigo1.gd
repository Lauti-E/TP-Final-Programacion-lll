extends CharacterBody2D

@export var velocidad: float = 0

var jugador: Node2D

func _ready():
	$Nave.play("idle")
	jugador = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if global_position.y > get_viewport_rect().size.y + 200:
		queue_free()

func _physics_process(_delta):
	
	move_and_slide()
