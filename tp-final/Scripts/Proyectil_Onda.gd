extends Area2D

@export var escenaOnda: PackedScene

@export var velocidad: float = 0.0

func _process(delta):
	global_position.y -= velocidad * delta

	if global_position.y < -10:
		queue_free()

func CrearOnda():
	if escenaOnda == null:
		return
	
	var onda = escenaOnda.instantiate()
	onda.global_position = global_position

	get_tree().current_scene.add_child(onda)

	queue_free()


func _on_body_entered(body):
	if body.is_in_group("Enemigo") or body.is_in_group("Asteroide"):
		call_deferred("CrearOnda")
