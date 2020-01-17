extends RigidBody2D

# The "dropped" signal is fired, when the ball leaves the viewport.
# It carries one Vector2 parameter which indicates where the ball was lost.
signal ball_lost

export var speedup = 4
export var max_speed = 300



var multiplier = 1

func get_class(): return "Ball"

func _physics_process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.get_class() == "Brick":
			body.register_hit(self)
			multiplier += 1

		elif body.get_class() == "Paddle":
			multiplier = 1
			var direction = position - body.get_reflector()
			linear_velocity = min(max_speed, linear_velocity.length() + speedup) * direction.normalized()

	if position.y > get_viewport_rect().size.y + 10:
		emit_signal("ball_lost", position)
		queue_free()