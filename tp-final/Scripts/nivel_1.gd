extends Node

@export var velScroll: float = 100.0

func _process(delta):
	$Camera2D.global_position.y -= velScroll * delta
