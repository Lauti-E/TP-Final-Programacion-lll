extends CharacterBody2D

@export var velocidad := 500.0

func _physics_process(_delta):
	# Movimiento de la nave.
	var dir := Vector2.ZERO
	
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		
	velocity = dir * velocidad
	
	move_and_slide()
	
	# Limitar el movimiento de la nave dentro de la cámara.
	var camara = $Camera2D
	
	var izq = camara.limit_left
	var der = camara.limit_right
	var arriba = camara.limit_top
	var abajo = camara.limit_bottom
	
	# Tomamos el tamaño desde la colisión.
	var shape = $CollisionShape2D.shape
	var extents = shape.get_rect().size / 2
	
	global_position.x = clamp(global_position.x, izq + extents.x + 25, der - extents.x - 25)
	global_position.y = clamp(global_position.y, arriba + extents.y - 25, abajo - extents.y - 25)
