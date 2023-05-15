extends Area2D

signal hited(damage : float)

func hit(damage):
	hited.emit(damage)
