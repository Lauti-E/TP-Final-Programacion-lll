extends Sprite2D

@export var duracion: float = 0.3

func _ready():
	# Desvanecimiento de la sombra.
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duracion)
	
	await tween.finished
	queue_free()
