extends Node


func _ready():
	$Score.text = "Score: " + str(Global.final_score)
	
