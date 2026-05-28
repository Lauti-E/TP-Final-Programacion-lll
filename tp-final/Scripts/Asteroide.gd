extends CharacterBody2D

# Variables generales del asteroide.
@export var velCaida: float = 0.0
@export var danColision: int = 0

func _physics_process(_delta):
	velocity = Vector2(0, velCaida)
	
	move_and_slide()
	
	var altoPantalla = get_viewport_rect().size.y
	
	if global_position.y > altoPantalla + 100:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		
		if body.has_method("RecibirDan"):
			body.RecibirDan(danColision)
		queue_free()
