extends Enemigo

@export var escenaProyectil: PackedScene

@export var velocidadProyectil: float = 0.0
@export var danioProyectil: int = 0

func _ready():
	super()
	
	$Nave.play("idle")

func Disparo():
	var proyectil = escenaProyectil.instantiate()

	proyectil.velProyectil = velocidadProyectil
	proyectil.danio = danioProyectil
	
	get_tree().current_scene.add_child(proyectil)
	
	proyectil.global_position = $"Punto Disparo".global_position

	if jugador != null:
		proyectil.ApuntarA(jugador.global_position)
