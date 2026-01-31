extends CharacterBody2D

@export var velocidadMax := 200.0
@export var aceleracion := 1200.0
@export var friccion := 1000.0

func _physics_process(delta):
	var direccion := Vector2.ZERO
	
	direccion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direccion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if direccion != Vector2.ZERO:
		direccion = direccion.normalized()
		
		# Velocidad objetivo.
		var velObjetivo = direccion * velocidadMax
		
		# Acelerar suavemente hacia esa velocidad.
		velocity = velocity.move_toward(velObjetivo, aceleracion * delta)
	else:
		#Si no hay input, frenar suavemente.
		velocity = velocity.move_toward(Vector2.ZERO, friccion * delta)
	
	
	
	move_and_slide()
