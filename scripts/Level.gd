extends Node2D

# Aggregates the "broken" signals
# Signal brick_broken { brick: Brick, ball_multiplier: Int }
signal clear_brick

signal clear_level

func _on_brick_broken (brick, hp):
	emit_signal("clear_brick", brick, hp)

	if get_child_count() == 0:
		emit_signal("clear_level")

func _ready():
	# Aggregate the "broken" signals
	for child in get_children():
		child.connect("brick_broken", self, "_on_brick_broken")