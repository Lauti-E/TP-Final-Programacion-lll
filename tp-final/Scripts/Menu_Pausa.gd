extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_reanudar_pressed():
	get_tree().get_first_node_in_group("GameManager").EnPausa()

func _on_salir_pressed():
	get_tree().quit()
