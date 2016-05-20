require "kemal"
require "./todo.cr"

before_all "/todos" do |context|
  # CORS header
  context.response.headers["Access-Control-Allow-Origin"] = "*"

  # application/json
  context.response.content_type = "application/json"
end

get "/todos" do |context|
  if todos = Todo.all
    todos.to_json
  else
    "Could not find Todos".to_json
  end
end

post "/todos" do |context|
  if todo = Todo.new
    todo.create(context.params.body)
    todo.to_json
  else
    "Could not create Todo.".to_json
  end
end
 
delete "/todos" do |context|
  if Todo.clear
    "Success".to_json
  else
    "Could not clear Todos".to_json
  end
end

get "/todos/:uid" do |context|
  uid = context.params.url["uid"]
  if todo = Todo.find uid
    todo.to_json
  else
    "Could not search for Todo".to_json
  end
end

patch "/todos/:uid" do |context|
  uid = context.params.url["uid"]
  if todo = Todo.find uid
    todo.update(context.params.body)
    todo.to_json
  else
    "Todo with id:#{uid} could not be found".to_json
  end
end

delete "/todos/:uid" do |context|
  uid = context.params.url["uid"]
  if todo = Todo.delete uid
    "Success".to_json
  else
    "Could not destroy Todo #{uid}".to_json
  end  
end

Kemal.run
