extends CharacterBody2D

@export var velocidad := 500.0

func _physics_process(_delta):
	var dir := Vector2.ZERO
	
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		
	velocity = dir * velocidad
	
	move_and_slide()
