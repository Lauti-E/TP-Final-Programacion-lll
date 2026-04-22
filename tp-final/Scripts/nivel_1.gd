extends Node

@onready var espacioLayer: ParallaxLayer = %EspacioLayer
@onready var estrellasLejanasLayer: ParallaxLayer = %EstrellasLejanasLayer
@onready var estrellasCercanasLayer: ParallaxLayer = %EstrellasCercanasLayer

func _process(delta):
	espacioLayer.motion_offset.y += 2 * delta
	estrellasLejanasLayer.motion_offset.y += 5 * delta
	estrellasCercanasLayer.motion_offset.y += 20 * delta
