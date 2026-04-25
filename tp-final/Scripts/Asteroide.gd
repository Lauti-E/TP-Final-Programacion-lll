extends CharacterBody2D

@export var velCaida: float = 50.0

func _physics_process(delta):
	velocity = Vector2(0, velCaida)
	
	move_and_slide()
	
	var altoPantalla = get_viewport_rect().size.y
	
	if global_position.y > altoPantalla + 100:
		queue_free()
