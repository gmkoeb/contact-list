def login(user)
  post user_session_path, params: { user: { email: user.email, password: user.password } }
  json_response = JSON.parse(response.body)
  json_response['status']['data']['Authorization']['token']
end
