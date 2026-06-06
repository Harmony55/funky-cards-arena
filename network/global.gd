extends Node

var board

var need_hurt = false

var other_id

var orbe = 30

var dataBaseCosmetics = []

var onExtra = false

var music_time = 0
var music_timeCasier = 0
var sameIP

const thatTime = 0

var cardsHad = {}

var lastScreen

var play_turn = 1 #Nombre de tour que les gens on jouer
var real_turn = 1 #Tour afficher

var couleurVives = false

var orbeSelected = "Orbe Verte"
var skinSelected = ":lovide:"
var arenaSelected = "Funky Cards Arena"

var deckSelect = null

var deconnected = false
var canPlay = false

puppet var puppet_real_turn

func instance_node_at_location(node: Object, parent: Object, location: Vector2):
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance
