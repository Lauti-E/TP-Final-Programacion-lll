extends Enemigo

@export var escenaProyectil: PackedScene

func _ready():
	super()
	
	$Nave.play("idle")

func Disparo():
	var proyectil = escenaProyectil.instantiate()
	
	get_tree().current_scene.add_child(proyectil)
	
	proyectil.global_position = $"Punto Disparo".global_position
