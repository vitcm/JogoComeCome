extends ParallaxLayer

# Velocidade de rolagem
var scroll_speed = 200  # Ajuste conforme necessário
var width = 2303.08764648438 # Substitua pelo valor da largura da sua imagem

func _process(delta):
	# Movendo a imagem da direita para a esquerda
	motion_offset.x -= scroll_speed * delta

	# Verifica se o offset passou da largura da imagem
	if motion_offset.x < -width:
		# Reseta para criar o loop contínuo
		motion_offset.x += width  # Em vez de zerar, adicionamos a largura para criar o loop


func _on_button_pressed() -> void:
	pass # Replace with function body.
