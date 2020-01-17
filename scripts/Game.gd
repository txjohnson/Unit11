extends Node2D

const ball_scene = preload("res://objects/Ball.tscn")
const balloon_msg = preload("res://objects/Balloon.tscn")

const levels = [
	preload("res://scenes/levels/Level00.tscn")
]

var score = 0
var health = 100
var balls_in_play :int = 0

export var health_loss :int = 35
export var level :int = 1

func _ready():
	load_level()
	pass # Replace with function body.



func _on_Ball_ball_lost (where):
	health -= health_loss * level
	print (health_loss)
	update_health_label()
	
	if health <= 0:
		# TODO: Figure out how to transfer the score value to the game_over scene.
		Global.final_score = score
		get_tree().change_scene("res://scenes/Game Over.tscn")
	
	var label_position = Vector2(where.x, get_viewport_rect().size.y)
	spawn_label (str(-health_loss), label_position, Color(1, 0, 0))
	
	update_instructions()
	pass

func _on_Paddle_launch_a_ball (from):
	var ball = ball_scene.instance()
	ball.position = from.position - Vector2(0, 16)
	$Balls.add_child(ball)
	ball.connect("ball_lost", self, "_on_Ball_ball_lost")
	update_instructions ()

func _on_clear_brick (brick, brick_hp):
	var additional_score = brick_hp * level * $Balls.get_child_count()
	score += additional_score
	health += additional_score
	spawn_label (str(additional_score), brick.position, Vector3(21/255, 189/255, 173/255))
	update_score_label()
	update_health_label()
	
	# Show a label with the score value to inform the player.
#	spawn_label(str(additional_score), brick.position, brick.modulate)

func _on_clear_level ():
	# delete all active balls
	for child in $Balls.get_children():
		child.queue_free()
		
	level = level + 1
	load_level()
	update_instructions()


func update_instructions():
	var ball_count = $Balls.get_child_count()
	if ball_count == 0:
		$HUD/Instructions.text = "Press left mouse button to launch a ball."
	elif ball_count == 1:
		$HUD/Instructions.text = "You can launch more than one ball at a time."
	elif ball_count >= 2:
		$HUD/Instructions.text = "You lose "+str(health_loss)+" health for each dropped ball."


func load_level():
	var l = levels [(level-1) % levels.size()] .instance();
	l.connect("clear_brick", self, "_on_clear_brick")
	l.connect("clear_level", self, "_on_clear_level")
	$Bricks.replace_by (l)
	

func update_score_label():
	$HUD/Score.text = "Score: " + str(score)

func update_health_label():
	$HUD/Health.text = "Health: " + str(health)

# Show a label with the score value to inform the player.
func spawn_label(caption, label_position, label_color):
	var score = balloon_msg.instance()
	score.set_caption(caption)
	# Copy brick position and color
	score.position = label_position
	add_child(score)
