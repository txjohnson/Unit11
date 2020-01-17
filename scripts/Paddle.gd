extends KinematicBody2D

signal launch_a_ball

var max_speed = 1000

func get_class (): return "Paddle"


func _physics_process(delta):
	var target = get_viewport().get_mouse_position().x
	
	if target < 0.0: target = 0.0
	if target > 1280.0: target = 1280.0
	
	if target < position.x:
		position.x = max(target, position.x - max_speed * delta)
	elif target > position.x:
		position.x = min(target, position.x + max_speed * delta)

func _input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed() and event.button_index == 1:
			print("Launching a ball...")
			emit_signal("launch_a_ball", self)


func get_reflector ():
	return $Reflector.get_global_position()