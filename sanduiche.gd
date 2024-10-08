extends CharacterBody2D

const SPEED = 200.0

# Sinal para notificar que o sanduíche foi comido
signal sanduiche_comido

# Variável para armazenar a referência ao AnimatedSprite2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Garante que a animação do sanduíche esteja em loop
	sprite.play("movimentoSand")

func _physics_process(delta: float) -> void:
	# Movimenta o sanduíche para a direita
	velocity.x = SPEED
	move_and_slide()

	# Se o sanduíche sair da tela, removê-lo
	if position.x > get_viewport_rect().size.x + sprite.get_sprite_frames().get_frame_texture("movimentoSand", 0).get_size().x:
		queue_free()

	# Verifica se o sanduíche colidiu com a BarraFinal ou ComiComi
	for i in range(get_slide_collision_count()):  # Corrigido para get_slide_collision_count()
		var collided_body = get_slide_collision(i).get_collider()  # Obtém o corpo colidido
		if collided_body:  # Verifica se colidiu com algo
			if collided_body.name == "BarraFinal":
				queue_free()  # Remove o sanduíche da cena
			elif collided_body.name == "ComiComi":  # Verifica se colidiu com o ComiComi
				emit_signal("sanduiche_comido")  # Emite o sinal de sanduíche comido
				queue_free()  # Remove o sanduíche da cena
