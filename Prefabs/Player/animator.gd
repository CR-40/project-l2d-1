extends AnimatedSprite2D

@onready var player: Player = $".."

func _physics_process(_delta: float) :
	handle_flip()
	
	if player.is_attacking :
		#print("is player attacking: "+ str(player.is_attacking))
		#print("attempting to play attack anim")
		attack()
		return
	
	idle()
	rise()
	fall()
	move()


func idle():
	if player.velocity.x == 0:
		play("idle")

func rise():
	if player.velocity.y > 0:
		play("rise")

func fall():
	if player.velocity.y < 0:
		play("fall")

func move():
	if player.velocity.x != 0 :
		play("move")

func attack():
	if player.is_attacking:
		play("attack")
		player.is_attacking = false

func handle_flip():
	if player.face_direction > 0:
		flip_h = false
	if player.face_direction < 0:
		flip_h = true
