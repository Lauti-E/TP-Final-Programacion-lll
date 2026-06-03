extends Area2D

@export var escalaFinal: float = 0.0
@export var duracion: float = 0.0

func _ready():
	scale = Vector2.ONE * 0.1
	
	var crecimiento = create_tween()
	crecimiento.tween_property(self, "scale", Vector2.ONE * escalaFinal, duracion)
	
	await crecimiento.finished
	
	queue_free()
