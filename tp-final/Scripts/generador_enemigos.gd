extends Node2D

# Referencias.
@export var camara: Camera2D
@export var escenaEnemigo: PackedScene

@export var activarUnaVez: bool = true
@export var margenBorrado: float = 100

var activado: bool = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _process(_delta):
	if camara == null:
		return
	
	var limiteAbajo = camara.global_position.y + get_viewport_rect().size.y
	
	if global_position.y > limiteAbajo + margenBorrado:
		queue_free()
		print("Spawner borrado.")

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
	
	var puntosSpawn = []
	
	for hijo in $PosicionesSpawns.get_children():
		if hijo is Marker2D:
			puntosSpawn.append(hijo)
	
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
