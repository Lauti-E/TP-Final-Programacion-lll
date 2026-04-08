extends Node2D

@export var escenaEnemigo: PackedScene
@export var activarUnaVez: bool = true

var activado: bool = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	
	add_to_group("player")

func _on_body_entered(body):
	if activado and activarUnaVez:
		return
	
	if body.is_in_group("player"):
		call_deferred("SpawnearEnemigo")
		activado = true

func SpawnearEnemigo():
	if escenaEnemigo == null:
		print("No hay enemigo asignado.")
		return
	
	var puntosSpawn = $PosicionesSpawns.get_children()
	
	print("Cantidad de puntos:", puntosSpawn.size())
	
	if puntosSpawn.size() == 0:
		print("No hay puntos de spawn.")
		return
		
	# Elegir un punto aleatorio.
	var punto = puntosSpawn.pick_random()
	
	print("Spawn en:", punto.name)
	
	var enemigo = escenaEnemigo.instantiate()
	
	# Usar el Marker2D para la posición del enemigo.
	enemigo.global_position = punto.global_position
	
	get_tree().current_scene.add_child(enemigo)
