extends Node


func read_json_file(file):
	var json_as_text = FileAccess.get_file_as_string(file)
	if json_as_text == "":
		printerr("Failed to read json file: " + file)
	var json_as_dict = JSON.parse_string(json_as_text)
	if not json_as_dict:
		printerr("Failed to parse json file: " + file)
		return null
	return json_as_dict
