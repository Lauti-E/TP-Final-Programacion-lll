extends Enemigo

func _ready():
	super()
	
	$Nave.play("idle")
	add_to_group("Enemigo")
