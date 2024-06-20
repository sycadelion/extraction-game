extends Control

@export var errorName = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/MarginContainer/HBoxContainer/ErrorName.text = errorName


func _on_accept_button_pressed() -> void:
	$".".visible = false
