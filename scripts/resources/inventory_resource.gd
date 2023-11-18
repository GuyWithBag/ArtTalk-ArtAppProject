extends Resource
class_name InventoryResource

signal inventory_changed(previous_items: Array[ItemResource], new_items: Array[ItemResource], changed_by: Node )

signal new_items_set(new_items: Array[ItemResource], added_by: Node)

signal items_added(new_items: Array[ItemResource], added_by: Node)
signal item_added(new_item: ItemResource, added_by: Node)

signal items_taken(new_items: Array[ItemResource], taken_by: Node)
signal item_taken(new_item: ItemResource=, taken_by: Node)

signal items_removed(new_items: Array[ItemResource], taken_by: Node)
signal item_removed(new_item: ItemResource, removed_by: Node)

@export var items: Array[ItemResource] = []


func set_items(new_items: Array[ItemResource], added_by: Node) -> void:
	items = new_items
	emit_signal("new_items_set", new_items, added_by)


func add_items(new_items: Array[ItemResource], added_by: Node) -> void:
	items.append_array(new_items)
	emit_signal("items_added", new_items, added_by)


func add_item(new_item: ItemResource, added_by: Node) -> void:
	items.append(new_item)
	emit_signal("item_added", new_item, added_by)


func take_all_items(taken_by) -> Array[ItemResource]:
	var all_items: Array[ItemResource] = items.duplicate()
	items.clear()
	emit_signal("item_taken", all_items, taken_by)
	return all_items


func take_items(new_items: Array[ItemResource], taken_by: Node) -> Array[ItemResource]:
	var _items: Array[ItemResource] = []
	for new_item in new_items:
		_items.append(items.pop_at(find_item(new_item)))
	emit_signal("item_taken", _items, taken_by)
	return _items


func take_item(new_item: ItemResource, taken_by: Node) -> ItemResource:
	var _item = items.pop_at(find_item(new_item))
	emit_signal("item_taken", _item, taken_by)
	return _item


func remove_items(new_items: Array[ItemResource], taken_by: Node) -> void:
	var taken_items: Array[ItemResource] = []
	for new_item in new_items:
		taken_items.append(items.pop_at(find_item(new_item)))
	emit_signal("items_removed", taken_items, taken_by)


func remove_item(new_item: ItemResource, removed_by: Node) -> void:
	items.erase(new_item)
	emit_signal("item_removed", new_item, removed_by)


func has_item(item: ItemResource) -> bool:
	if items.find(item) > -1:
		return true
	return false


func find_item(item: ItemResource) -> int:
	return items.find(item)


func has_item_by_name(item_name: StringName) -> bool:
	if find_item_by_name(item_name) > -1:
		return true
	return false


func find_item_by_name(item_name: StringName) -> int:
	for i in items.size():
		if items[i].item_name == item_name:
			return i
	return -1


func load_items_by_names(item_names: Array[String], added_by: Node = null) -> void: 
	var new_items: Array[ItemResource] = []
	for item_name in item_names: 
		new_items.append(ItemLoader.get_item(item_name))
	set_items(new_items, added_by)


func save_data() -> Dictionary:
	var _items: Array[String] = []
	for item in items:
		_items.append(item.item_name)
	var data: Dictionary = {
		"items" : _items
	}
	return data


func is_empty() -> bool: 
	if items.is_empty(): 
		return true
	return false


func _to_string() -> String:
	var _items: String = ""
	for index in items.size(): 
		if index == 0: 
			_items += items[index].item_name
		_items += " , " + items[index].item_name
	return _items
	
	
