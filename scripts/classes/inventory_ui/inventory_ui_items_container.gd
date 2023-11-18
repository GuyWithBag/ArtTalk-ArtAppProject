extends GridContainer
class_name InventoryUIItemsContainer

signal item_slot_pressed(item_slot: ItemSlot)

@export var min_amount_of_slots: int = 10
@export var have_option_button: bool = true

var current_amount_of_slots: int = min_amount_of_slots
var item_slot_uid: PackedScene = load("res://ui/player_inventory_ui/inventory_item_slot/inventory_item_slot.tscn")
var item_slot_dropdown_menu_uid: String = "res://ui/player_inventory_ui/inventory_item_slot_dropdown_menu/inventory_item_slot_dropdown_menu.tscn"
var item_slot_dropdown_menu: InventoryItemSlotDropdownMenu
var items: Array[ItemResource]
var item_slots: Array[ItemSlot]

func _ready() -> void:
	set_item_slots_list()


func _on_item_slot_pressed(item_slot: ItemSlot) -> void:
	if have_option_button:
		_set_option_button_active(true, item_slot)
	item_slot_pressed.emit(item_slot)


func _set_option_button_active(active: bool, item_slot: ItemSlot) -> void:
	item_slot_dropdown_menu = load(item_slot_dropdown_menu_uid).instantiate()
	UIManager.add_gui(item_slot_dropdown_menu)
	item_slot_dropdown_menu.set_dropdown_active(active, item_slot)
	
	
func set_item_slots_list() -> void:
	item_slots.clear()
	item_slots.append_array(self.get_children())
	current_amount_of_slots = item_slots.size()


func set_items_array(new_items: Array[ItemResource]) -> void:
	items = new_items


func append_to_items_array(item: ItemResource) -> void:
	items.append(item)


func load_items_into_ui() -> void:
	var items_size = items.size()
	for i in items_size:
		var item = items[i]
		# If the item slots exceed the minimum amount of item slots, 
		# it will add an item slot note instead of just setting it
		add_item(item, items_size, i)
	set_item_slots_list()
	for item_slot in item_slots:
		item_slot.pressed.connect(func(): _on_item_slot_pressed(item_slot))
	
# Unfinished code
func reload_items_from_ui() -> void:
	var extra_items: int = current_amount_of_slots - min_amount_of_slots
	for i in extra_items:
		remove_item_slot(item_slots.pop_back())
	set_item_slots_list()
	items.clear()
	for item_slot in item_slots:
		clear_item_slot_data(item_slot)
	

func add_item(item: ItemResource, _size: int, index: int) -> void:
	var item_slot: ItemSlot = item_slots[index]
	if _size + 1 < min_amount_of_slots:
		set_item_slot_an_item(item_slot, item)
	else:
		add_item_slot(item)
	


func add_item_slot(item: ItemResource) -> void:
	var item_slot: Button = item_slot_uid.instantiate()
	self.add_child(item_slot)
	set_item_slot_an_item(item_slot, item)
	item_slots.append(item_slot)
	
	
func remove_item_slot(item_slot: ItemSlot):
	item_slot.queue_free()
	
	
func set_item_slot_an_item(item_slot: ItemSlot, item: ItemResource) -> void:
	item_slot.item = item
	item_slot.icon = item.item_icon
	item_slot.text = item.item_name
	item_slot.disabled = false
	
	
func clear_item_slot_data(item_slot: ItemSlot) -> void:
	item_slot.item = ItemResource.new()
	item_slot.icon = Texture.new()
	item_slot.text = ""
	item_slot.disabled = true


func take_item(item_slot: ItemSlot) -> ItemResource:
	var item = item_slot.item
	clear_item_slot_data(item_slot)
	re_sort_item_slots()
	return item
	
	
func re_sort_item_slots() -> void:
	load_items_into_ui()
	
