extends CharacterBody2D

@export var velocidad := 200.0 

func _physics_process(delta):
	var dir := Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_just_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_just_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_just_pressed("ui_up"):
		dir.y -= 1
		
	if dir != Vector2.ZERO:
		dir = dir.normalized()
	
	velocity = dir * velocidad
	
	move_and_slide()
