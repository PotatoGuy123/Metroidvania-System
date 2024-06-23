extends CharacterBody2D
signal damage(value)
var health = 75

@export var move_speed : float = 150
@export var initial_move_direction : int = 1

var move_direction : int

func _ready():
	move_direction = initial_move_direction

func _physics_process(delta):
	velocity.x = move_speed * move_direction
	
	if !is_on_floor():
		velocity.y += 9.8
	else:
		velocity.y = 0
	
	
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(15)
		
	
	move_direction *= -1
	
func take_damage(value):
	health -= value
	if health <= 0:
		kill()

func kill():
	queue_free()
