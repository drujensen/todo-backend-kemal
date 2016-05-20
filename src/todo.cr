require "secure_random"

class Todo
  property uid : String
  property title : String
  property order : Int32
  property completed : Bool

  JSON.mapping({
    uid: String,
    title: String,
    order: Int32,
    completed: Bool,
    url: String
  })

  def self.todos
    @@todos ||= [] of Todo
  end

  def self.all
    Todo.todos
  end

  def self.find(uid : String)
    Todo.todos.select{|todo| todo.uid == uid}.first
  end
 
  def self.clear
    Todo.todos.clear
  end
  
  def self.delete(uid : String)
    if todo = find uid
      Todo.todos.delete todo
    end
  end

  def initialize
    @uid = SecureRandom.uuid
    @title = ""
    @order = 0
    @completed = false
    @url = "https://todo-backend-kemal.herokuapp.com/todos/#{uid}"
  end
 
  def create(params)
    update(params)
    Todo.todos << self
    self
  end

  def update(params)
    if params.has_key? "title"
      @title = params["title"]
    end
    if params.has_key? "order"
      @order = params["order"].to_i32
    end
    if params.has_key? "completed"
      @completed = (params["completed"] == "true")
    end
    self
  end
end
