extends CharacterBody2D

const SPEED = 200.0

# Variável para armazenar a referência ao AnimatedSprite2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Garante que a animação do veneno esteja em loop
	sprite.play("movimentoVene")

func _physics_process(delta: float) -> void:
	# Movimenta o veneno para a direita
	velocity.x = SPEED
	move_and_slide()

	# Se o veneno sair da tela, removê-lo
	if position.x > get_viewport_rect().size.x + sprite.get_sprite_frames().get_frame_texture("movimentoVene", 0).get_size().x:
		queue_free()

	# Verifica se o veneno colidiu com a BarraFinal ou ComiComi
	for i in range(get_slide_collision_count()):
		var collided_body = get_slide_collision(i).get_collider()
		if collided_body:
			if collided_body.name == "ComiComi":
				collided_body.take_damage()  # Chama a função de dano no ComiComi
				queue_free()  # Remove o veneno da cena
			elif collided_body.name == "BarraFinal":
				queue_free()
