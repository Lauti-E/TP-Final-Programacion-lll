extends CharacterBody2D

@export var velCaida: float = 50.0
@export var danColision: float = 30

func _physics_process(_delta):
	velocity = Vector2(0, velCaida)
	
	move_and_slide()
	
	var altoPantalla = get_viewport_rect().size.y
	
	if global_position.y > altoPantalla + 100:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
