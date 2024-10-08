extends Node2D  # Ou Node, dependendo de como você estruturou

const VENENO_SPAWN_TIME = 1.0  # Tempo entre spawns (1 segundo)
const MAX_VENENOS = 5  # Máximo de sanduíches permitidos na cena

var spawn_timer: Timer

func _ready() -> void:
	# Cria um timer para gerar os sanduíches
	spawn_timer = Timer.new()
	spawn_timer.wait_time = VENENO_SPAWN_TIME
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_spawn_veneno"))
	add_child(spawn_timer)
	spawn_timer.start()  # Inicia o timer

# Função para spawnar um novo sanduíche
func _spawn_veneno() -> void:
	# Verifica quantos sanduíches já estão na cena
	var sanduiches_atual = get_children().filter(func(child): return child.name == "Veneno")
	
	if sanduiches_atual.size() < MAX_VENENOS:  # Limite de sanduíches na cena
		var new_sanduiche = preload("res://veneno.tscn").instantiate()  # Carregue a cena do sanduíche
		new_sanduiche.name = "Veneno"  # Atribui um nome ao novo sanduíche

		# Posiciona o novo sanduíche na borda esquerda da tela com uma posição Y aleatória
		var screen_size = get_viewport_rect().size
		var sprite = new_sanduiche.get_node("AnimatedSprite2D")  # Certifique-se de que o nome esteja correto
		if sprite:  # Verifica se o sprite existe
			new_sanduiche.position = Vector2(
				-sprite.get_sprite_frames().get_frame_texture("movimentoVene", 0).get_size().x / 2,
				randf_range(0, screen_size.y)
			)

		# Adiciona o novo sanduíche à cena
		add_child(new_sanduiche)
