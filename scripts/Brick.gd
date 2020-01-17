extends StaticBody2D

# Signal broken { brick: Brick, ball_multiplier: Int }
signal brick_broken

export var initial_hitpoints = 1
var hitpoints

func get_class (): return "Brick"

func _ready():
	randomize()
	hitpoints = initial_hitpoints
	modulate = Color(randf(), randf(), randf())
	modulate.s = 1
	modulate.v = 0.5

# Called, when a ball hits the brick.
func register_hit (ball):
	hitpoints -= 1
	if hitpoints <= 0:
		# FIXME: First check if I have a parent.
		get_parent().remove_child(self) # Important for counting.
		emit_signal("brick_broken", self, initial_hitpoints)
		queue_free()
	else:
		# TODO: Add more damage states (and images)
		var sprite = find_node("sprite")
		$Sprite.frame = randi() % 3 + 1

