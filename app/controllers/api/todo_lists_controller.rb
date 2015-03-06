class Api::TodoListsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def index
		render json: TodoList.all
	end
	def show
  	list = current_user.todo_lists.find(params[:id])
  	render json: list.as_json(include:[:todo_items])
	end
	def create
	list = TodoList.new(list_params)
	if list.save
		render status: 200, json: {
			message: "Successfully created todo list.",
			todo_list: list
		}.to_json
	else
		render status: 422, json: {
			errors: list.errors
		}.to_json
	end
end
def update
	list = TodoList.find(params[:id])
	if list.update(list_params)
		render status: 200, json: {
			message: "Successfully updated todo list.",
		}.to_json
	else
		render status: 422, json: {
			message: "Todo list could not be updated.",
			todo_list: list
		}.to_json
	end
end
	def destroy
		list = TodoList.find(params[:id])
		list.destroy
		render status: 200, json: {
			message: "Successfully deleted todo list.",
		}.to_json
	end
	private
	def list_params
		params.require("todo_list").permit("title")
	end
end