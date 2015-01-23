require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/category")
require("./lib/expense")
require("pg")
require("pry")

DB = PG.connect({:dbname => "expense_organizer"})

get("/") do
  erb(:index)
end

get("/categories/:id") do
  @id = params["id"].to_i()

  erb(:categories)
end

get("/expenses/:id") do
  @id = params["id"].to_i()
  erb(:expenses)
end

post("/categories") do
  category_name = params['category_name'].strip()
  if category_name !=""
    new_category = Category.new({:category_name => category_name})
    new_category.save()
  end
  erb(:index)
end

post("/expenses") do
  description = params['description'].strip()
  cost = params['cost'].strip()
  date = params['date'].strip()
  if description != "" && cost != "" && date != ""
    new_expense = Expense.new({:description => description, :cost => cost, :date => date})
    new_expense.save()
  end
  erb(:index)
end

post("/categories/:id") do

  erb(:categories)
end

post("/expenses/:id") do
  id = params['id'].to_i()
  category_id = params["category_id"]
  category = Category.find(category_id)
  category.add_expense_to_category(@expense)
  erb(:expenses)
end
