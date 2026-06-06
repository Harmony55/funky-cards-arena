extends Node2D


func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_Button_pressed():
#	_make_post_request("https://unbelievaboat.com/api/v1/guilds/857687589241749515/users/747353594399031436", ["cash: 100","bank: 50"], false)
	$HTTPRequest.request("https://unbelievaboat.com/api/v1/guilds/640162391585193997/users/", ["Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBfaWQiOiI5ODE4MzM5MjE3NjU0NDM3NDAiLCJpYXQiOjE2NTQxNTc4NDh9.4fL8KJGFJ29isqRhQKG7tEcTOOT8fdVYvjJuDrudjLA"])

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	
func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	print(query)
	# Add 'Content-Type' header:
	var headers = ["Accept: application/json","Content-Type: application/json","Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBfaWQiOiI5ODE4MzM5MjE3NjU0NDM3NDAiLCJpYXQiOjE2NTQxNTc4NDh9.4fL8KJGFJ29isqRhQKG7tEcTOOT8fdVYvjJuDrudjLA"]
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
