extends Node

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	seed(rng.seed)
	print("seed = ", rng.seed)
