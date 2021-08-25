require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo = todos(:one)
  end

  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should create todo" do
    assert_difference('Todo.count') do
      post todos_url, params: { todo: { completed: @todo.completed, title: @todo.title } }
    end

    assert_redirected_to root_url
  end

  test "should redirect todo to root" do
    get todo_url(@todo)
    assert_redirected_to root_url
  end

  test "should show JSON todo" do
    get todo_url(@todo, format: :json)
    assert_response :success
    assert_equal 'application/json; charset=utf-8', response.content_type
  end

  test "should update todo" do
    patch todo_url(@todo), params: { todo: { completed: @todo.completed, title: @todo.title } }
    assert_redirected_to root_url
  end

  test "should toggle all todos" do
    assert_difference('Todo.completed.count', 2) do
      patch toggle_all_todos_url
    end
    assert_redirected_to root_url

    assert_difference('Todo.completed.count', -3) do
      patch toggle_all_todos_url
    end
    assert_redirected_to root_url
  end

  test "should destroy todo" do
    assert_difference('Todo.count', -1) do
      delete todo_url(@todo)
    end

    assert_redirected_to root_url
  end

  test "should clear all completed todos" do
    todos(:two).update!(completed: true)

    assert_difference('Todo.completed.count', -2) do
      delete clear_completed_todos_url
    end

    assert_redirected_to root_url
  end
end