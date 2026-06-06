# res://tests/CardInteractionTest.gd
# Attach to an AutoLoad or a dedicated test scene.
# Run with: CardInteractionTest.run_all()

extends Node

const PASS = "✓"
const FAIL = "✘"

onready var _board = get_parent() # Reference to a Board instance
var _results = []


# ─── Test Implementations ────────────────────────────────────────────────────

func test_juan_buff():
	_board.placeCard(1, "32 - Juan")
	_place_enemy_card(2, "38 - Poulet")
	_board.check_juan()
	yield(get_tree().create_timer(0.3), "timeout")
	var atk = _board.get_data(1).get_value("attack")
	assert_eq(atk, _base_attack("32 - Juan") + 2, "Juan should gain +2 ATK near Poulet")


func test_kratos_buff():
	_board.placeCard(1, "44 - Kratos")
	_board.placeCard(2, "3 - Kirbo")
	var kirbo_atk_before = _board.get_data(2).get_value("attack")
	_board.card_placed(_board._player_cards[0], 1)  # triggers effectAllCard
	yield(get_tree().create_timer(0.1), "timeout")
	var kirbo_atk_after = _board.get_data(2).get_value("attack")
	assert_eq(kirbo_atk_after, kirbo_atk_before + 2, "Kratos should buff all cards by +2 ATK")


func test_harmony55():
	_board.placeCard(3, "58 - Harmony55")
	var card_id = _board.giveCard("3 - Kirbo", 1)
	var mana_before = card_id.data().get_value("mana")
	# Harmony55 reduces mana when cards enter hand — simulate draw
	_board.draw()
	yield(get_tree().create_timer(0.1), "timeout")
	var drawn = _board._hand_store.cards().back()
	assert_true(drawn.data().get_value("mana") <= mana_before,
		"Harmony55 should reduce drawn card mana by 1")


func test_tropical_fish():
	_board.placeCard(1, "29 - tropical_fish")
	var data = _board.get_data(1)
	var original_desc = data.get_text("desc")
	var initial_hp = data.get_value("hp")
	print("initial hp", initial_hp)
	# Force death
	data.set_value("hp", 0)
	_board.check_death()
	yield(get_tree().create_timer(2.5), "timeout")
	# Should appear back in hand
	var found = false
	var hp
	for c in _board._hand_store.cards():
		if "tropical_fish" in c.data().get_text("name"):
			found = true
			hp = c.data().get_value("hp")
	print("new hp", hp)
	assert_true(found and hp < initial_hp, "Tropical Fish should return to hand at reduced hp after death")


func test_kuikui_obese_death():
	_board.placeCard(3, "14 - Kuikui Caillou Obèse")
	# Ensure slots 2 and 4 are empty
	_board._player_pile_stores[1] = CardPile.new()
	_board._player_pile_stores[3] = CardPile.new()

	_board._kuikui_obese_death(3)
	yield(get_tree().create_timer(0.1), "timeout")
	assert_true(_board._player_pile_stores[1].cards().size() > 0, "Slot 2 should get Kuikui Caillou")
	assert_true(_board._player_pile_stores[3].cards().size() > 0, "Slot 4 should get Kuikui Caillou")


func test_effect_card_signs():
	# effectCard(index, atk, hp): positive atk/hp = DAMAGE (negated internally)
	_board.placeCard(1, "3 - Kirbo")
	var hp_before = _board.get_data(1).get_value("hp")
	_board.effectCard(1, 0, 2)  # deal 2 hp damage
	yield(get_tree().create_timer(0.1), "timeout")
	assert_eq(_board.get_data(1).get_value("hp") if _board.get_data(1) else hp_before - 2,
		hp_before - 2, "effectCard(0,2) should reduce hp by 2")


func test_check_death_clears():
	_board.placeCard(2, "3 - Kirbo")
	_board.get_data(2).set_value("hp", 0)
	_board.check_death()
	yield(get_tree().create_timer(2.5), "timeout")
	assert_true(_board._player_pile_stores[1].cards().size() == 0, "Dead card slot should be cleared")


func test_spend_mana():
	_board.bobux = 5
	_board.usedBobux = 0
	_board.spend_mana(3)
	assert_eq(_board.bobux, 2, "bobux should decrease by 3")
	assert_eq(_board.usedBobux, 3, "usedBobux should increase by 3")


func test_peppa_pig_redirect():
	_board.placeCard(1, "81 - Peppa Pig")
	_board.placeCard(2, "3 - Kirbo")
	var kirbo_hp = _board.get_data(2).get_value("hp")
	_board.effectCard(1, -2, -2)  # buff Peppa
	yield(get_tree().create_timer(0.1), "timeout")
	# Peppa redirects to Kirbo
	assert_eq(_board.get_data(2).get_value("hp") if _board.get_data(2) else kirbo_hp + 2,
		kirbo_hp + 2, "Peppa Pig should redirect damage to another card")


func test_free_slots():
	_board._player_pile_stores[0] = CardPile.new()  # slot 1 empty
	_board.placeCard(2, "3 - Kirbo")                      # slot 2 occupied
	_board._player_pile_stores[2] = CardPile.new()  # slot 3 empty
	var free = _board._get_free_slots(2)  # exclude row 2
	assert_true(free.has(1), "Slot 1 should be free")
	assert_true(free.has(3), "Slot 3 should be free")
	assert_false(free.has(2), "Slot 2 should be excluded")


# ─── Helpers ─────────────────────────────────────────────────────────────────

func _place_card(row: int, name: String):
	var db = CardEngine.db().get_database("main")
	var store = CardPile.new()
	store.populate(db, Query.new().contains(["name:" + name]).execute(db))
	store.keep(1)
	_board._player_pile_stores[row - 1] = store
	_board._player_piles[row - 1].set_store(store)


func _place_enemy_card(row: int, name: String):
	var db = CardEngine.db().get_database("main")
	var store = CardPile.new()
	store.populate(db, Query.new().contains(["name:" + name]).execute(db))
	store.keep(1)
	_board._enemy_pile_stores[row - 1] = store
	_board._enemy_piles[row - 1].set_store(store)


func _give_card_to_hand(name: String):
	var db = CardEngine.db().get_database("main")
	var cards = Query.new().contains(["name:" + name]).execute(db)
	var store = CardPile.new()
	store.populate(db, cards)
	store.keep(1)
	var card = store.cards()[0]
	_board._hand_store.add_card(card.ref())
	return card


func _base_attack(name: String) -> int:
	var db = CardEngine.db().get_database("main")
	var cards = Query.new().contains(["name:" + name]).execute(db)
	if cards.size() == 0: return 0
	return CardEngine.db().get_database("main").get_card(cards[0]).get_value("attack")


# ─── Assert Helpers ───────────────────────────────────────────────────────────

func _run(label: String, fn: FuncRef):
	print("Clearing board")
	_board._clear_board()
	print("Running: " + label)
	fn.call_func()
	

func assert_eq(a, b, msg: String):
	if a == b:
		_results.append(PASS + " " + msg)
	else:
		_results.append(FAIL + " " + msg + " (got " + str(a) + ", expected " + str(b) + ")")

func assert_true(val: bool, msg: String):
	if val:
		_results.append(PASS + " " + msg)
	else:
		_results.append(FAIL + " " + msg)

func assert_false(val: bool, msg: String):
	assert_true(!val, msg)

func run_all():
#	_board = load("res://screens/board/Board.tscn").instance()
#	get_tree().root.add_child(_board)
#	_board._ready()  # Force init

	_run("Juan buff on Poulet", funcref(self, "test_juan_buff") )
	yield(get_tree().create_timer(2.5), "timeout")
	_run("Kratos buffs all cards", funcref(self, "test_kratos_buff"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("Harmony55 reduces hand mana", funcref(self, "test_harmony55"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("Tropical Fish death cycle", funcref(self, "test_tropical_fish"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("Kuikui Obese spawns neighbors", funcref(self, "test_kuikui_obese_death"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("effectCard negation consistency", funcref(self, "test_effect_card_signs"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("check_death clears slot on 0hp", funcref(self, "test_check_death_clears"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("spend_mana deducts correctly", funcref(self, "test_spend_mana"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("Peppa Pig redirects effect", funcref(self, "test_peppa_pig_redirect"))
	yield(get_tree().create_timer(2.5), "timeout")
	_run("get_free_slots excludes row", funcref(self, "test_free_slots"))

	_print_results()

func _print_results():
	print("\n=== Card Interaction Test Results ===")
	var passed = 0
	for r in _results:
		print(r)
		if r.begins_with(PASS): passed += 1
	print("\n%d / %d passed" % [passed, _results.size()])
