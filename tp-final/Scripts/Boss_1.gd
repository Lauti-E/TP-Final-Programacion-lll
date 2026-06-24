extends CharacterBody2D

@export var velEntrada: float = 0.0
@export var posCombateY: float = 0.0

var entrando: bool = true

func _physics_process(delta):
    if entrando:
        velocity = Vector2(0, velEntrada)

        if global_position.y >= posCombateY:
            velocity.ZERO
            
    move_and_slide()