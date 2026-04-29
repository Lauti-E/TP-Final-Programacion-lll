extends Node2D

func _ready():
	var frames = $Explosion.sprite_frames
	
	frames.set_animation_loop("Flash", false)
	frames.set_animation_loop("Explosion", false)
	
	$Explosion.play("Flash")

func _on_explosion_animation_finished() -> void:
	if $Explosion.animation == "Flash":
		$Explosion.play("Explosion")
	elif $Explosion.animation == "Explosion":
		queue_free()
