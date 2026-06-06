extends Area2D

# Variables generales de la onda.
@export var escalaFinal: float = 0.0
@export var duracion: float = 0.0
@export var dan: int = 0

func _ready():
	scale = Vector2.ONE * 0.1
	
	var crecimiento = create_tween()
	crecimiento.set_parallel(true)
	
	crecimiento.tween_property(self, "scale", Vector2.ONE * escalaFinal, duracion)
	
	crecimiento.tween_property($Sprite2D, "modulate:a", 0.0, duracion)
	
	await crecimiento.finished
	
	queue_free()
