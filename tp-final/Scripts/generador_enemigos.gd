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
		SpawnearEnemigo()
		activado = true

func SpawnearEnemigo():
	if escenaEnemigo == null:
		print("No hay enemigo asignado.")
		return
	
	var enemigo = escenaEnemigo.instantiate()
	
	# Usar el Marker2D para la posición del enemigo.
	enemigo.global_position = $PosicionSpawn.global_position
	
	get_tree().current_scene.add_child(enemigo)
