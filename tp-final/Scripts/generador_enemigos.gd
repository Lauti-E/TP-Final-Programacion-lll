extends Node2D

@export var enemigoEscena: PackedScene
@export var cantidad: int = 3
@export var radioSpawn: float = 100.0

var activado: bool = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if activado:
		return
	
	if body.is_in_group("player"):
		SpawnEnemigos()
		activado = true
		
func SpawnEnemigos():
	for i in cantidad:
		var enemigo = enemigoEscena.instantiate()
		
		var offset = Vector2(
			randf_range(-radioSpawn, radioSpawn),
			randf_range(-radioSpawn, radioSpawn)
		)
		
		enemigo.global_position = global_position + offset
		
		get_tree().current_scene.add_child(enemigo)
