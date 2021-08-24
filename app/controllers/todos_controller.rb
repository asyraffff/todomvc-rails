class TodosController < ApplicationController
    before_action :set_todo, only: [:show, :update, :destroy]
  
    # GET /
    # GET /.json
    def index
      @todos = Todo.order(:created_at)
      if params[:scope].in?(%w[active completed])
        @todos = @todos.public_send(params[:scope])
      end
    end
  
    # GET /todos/1.json
    def show
      respond_to do |format|
        format.html { redirect_to root_url }
        format.json
      end
    end
  
    # POST /todos
    # POST /todos.json
    def create
      @todo = Todo.new(todo_params)
  
      respond_to do |format|
        if @todo.save
          format.html { redirect_back fallback_location: root_url, notice: 'Todo was successfully created.' }
          format.json { render :show, status: :created, location: @todo }
        else
          format.html { redirect_back fallback_location: root_url, notice: 'Todo was NOT successfully created.' }
          format.json { render json: @todo.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /todos/1
    # PATCH/PUT /todos/1.json
    def update
      respond_to do |format|
        if @todo.update_or_destroy(todo_params)
          format.html { redirect_back fallback_location: root_url, notice: 'Todo was successfully updated.' }
          format.json { render :show, status: :ok, location: @todo }
        else
          format.html { redirect_back fallback_location: root_url, notice: 'Todo was NOT successfully updated.' }
          format.json { render json: @todo.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH /todos/toggle_all
    # PATCH /todos/toggle_all.json
    def toggle_all
      Todo.toggle_all!
      respond_to do |format|
        format.html { redirect_back fallback_location: root_url, notice: 'Todos were successfully toggled.' }
        format.json { head :ok }
      end
    end
  
    # DELETE /todos/1
    # DELETE /todos/1.json
    def destroy
      @todo.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: root_url, notice: 'Todo was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    # DELETE /todos/clear_completed
    # DELETE /todos/clear_completed.json
    def clear_completed
      Todo.completed.delete_all
      respond_to do |format|
        format.html { redirect_back fallback_location: root_url, notice: 'All completed todos were successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_todo
        @todo = Todo.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def todo_params
        params.require(:todo).permit(:title, :completed)
      end
  end
  