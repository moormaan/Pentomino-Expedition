class_name PentominoDefinition

var name: String
var shape: Array
var color: Color

func _init(name: String, shape: Array, color: Color):
    self.name = name
    self.shape = shape
    self.color = color

func height():
    return shape.size()

func width():
    return shape[0].size()