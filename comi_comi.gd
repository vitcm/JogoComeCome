extends CharacterBody2D

const SPEED = 300.0
const SANDUICHE_SCORE_INCREMENT = 30  # Pontos por sanduíche
const SCORE_INCREMENT = 10  # Pontos por segundo
const MAX_VENENO_HITS = 3
# Variável para armazenar a referência ao AnimatedSprite2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var score_label: Label = $ScoreLabel  # Referência ao Label de pontuação
@onready var sanduiche_count_label: Label = $QuantidadeSanduiche  # Referência ao Label de contagem de sanduíches

var score: int = 0  # Variável para o score
var sanduiche_count: int = 0  # Contador de sanduíches comidos
var score_timer: Timer  # Timer para incrementar o score
var veneno_hits = 0
func _ready() -> void:
	# Garante que a animação do ComiComi esteja em loop
	sprite.play("movimento")

	# Define a posição inicial do score_label
	score_label.position = Vector2(10, 10)
	sanduiche_count_label.position = Vector2(10, 30)  # Ajuste conforme necessário

	# Cria o Timer para o score
	score_timer = Timer.new()
	score_timer.wait_time = 1.0  # Aumenta a pontuação a cada 1 segundo
	score_timer.connect("timeout", Callable(self, "_on_score_timer_timeout"))  # Conecta o timer ao método
	add_child(score_timer)  # Adiciona o Timer ao nó do ComiComi
	score_timer.start()
	
func spawn_sanduiche():
	var sanduiche_scene = preload("res://sanduiche.tscn")
	var sanduiche_instance = sanduiche_scene.instance()
	add_child(sanduiche_instance)
	sanduiche_instance.connect("sanduiche_comido", self, "_on_sanduiche_comido")
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("cima", "baixo")
	if direction:
		velocity.y = direction * SPEED
		sprite.play("movimento")
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Atualiza a posição do ScoreLabel para que fique fixo na tela
	if score_label:
		score_label.global_position = Vector2(10, 10)  # Mantém na parte superior esquerda da tela

# Função chamada quando um sanduíche é comido
func _on_sanduiche_comido() -> void:
	increase_sanduiche_count()  # Aumenta a contagem de sanduíches
	increase_score(SANDUICHE_SCORE_INCREMENT)  # Aumenta a pontuação

# Função para aumentar a contagem de sanduíches
func increase_sanduiche_count() -> void:
	sanduiche_count += 1  # Aumenta a contagem de sanduíches
	print("Sanduíches Comidos: ", sanduiche_count)

	# Atualiza o texto do Label de contagem de sanduíches
	if sanduiche_count_label:
		sanduiche_count_label.text = "Sanduíches Comidos: " + str(sanduiche_count)

# Função para aumentar a pontuação
func increase_score(increment: int) -> void:
	score += increment  # Aumenta o score
	print("Pontuação Atual: ", score)

	# Atualiza o texto do Label para exibir o score na tela
	if score_label:
		score_label.text = "Score: " + str(score)

# Função chamada a cada segundo para incrementar o score
func _on_score_timer_timeout() -> void:
	increase_score(SCORE_INCREMENT)  # Aumenta o score em 10 pontos

func take_damage() -> void:
	veneno_hits += 1  # Incrementa o contador de colisões com veneno
	if veneno_hits >= MAX_VENENO_HITS:
		die()

func die() -> void:
	queue_free()
	get_tree().paused = true  # Pausa o jogo
	
	get_tree().change_scene_to_file("res://game_over.tscn")

	# Para o Timer de pontuação
	score_timer.stop()
