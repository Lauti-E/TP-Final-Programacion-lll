extends Control

var cantCarriles: int
var cantBarras = []

func RecibirCarriles(cantidad: int):
	cantCarriles = cantidad
	print("Barras: ", cantBarras.size())
	print("Carriles: ", cantCarriles)

	if cantBarras.size() == cantCarriles:
		return

	# Obtener el tamaño de la ventana.
	var tamVentana = get_viewport_rect().size

	var anchoVentana = tamVentana.x
	var anchoCarril = anchoVentana / cantCarriles

	for i in cantCarriles:
		var barraInferior = ColorRect.new()
		barraInferior.color = Color(1, 0, 0, 0)
		barraInferior.size = Vector2(anchoCarril, 5)

		barraInferior.position = Vector2(i * anchoCarril, tamVentana.y - 5)
		
		self.add_child(barraInferior)
		cantBarras.append(barraInferior)
		print(barraInferior)

func ActualizarBarra(carril):
	await get_tree().process_frame
	
	var mayorY = 0.0

	for enemigo in get_tree().get_nodes_in_group("Enemigo"):
		if enemigo.carril == carril:
			if enemigo.global_position.y > mayorY:
				mayorY = enemigo.global_position.y
	
	if mayorY == 0:
		cantBarras[carril].color = Color(1, 0, 0, 0)
		return
	
	var tamVentana = get_viewport_rect().size

	var intensidad = inverse_lerp(tamVentana.y - 150, tamVentana.y, mayorY)

	cantBarras[carril].color = Color(1, 0, 0, intensidad)