extends Area2D

# Variables generales del área de spawn.
@export var velocidad: float = 20.0

# Variables para los enemigos.
@export var escenaEnemigo: PackedScene
@export var cantEnemigos: int = 3

func _process(delta):
	position.y += velocidad * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		
		call_deferred("GenerarEnemigos")
		
		call_deferred("queue_free")

func GenerarEnemigos():
	if escenaEnemigo == null:
		return
	
	var tamVentana = get_viewport_rect().size
	
	for i in cantEnemigos:
		var enemigo = escenaEnemigo.instantiate()
		
		var randomX = randf_range(0, tamVentana.x)
		var spawnY = -50
		
		enemigo.global_position = Vector2(randomX, spawnY)
		
		get_tree().current_scene.add_child(enemigo)
