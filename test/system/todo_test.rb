require "application_system_test_case"

class TodosTest < ApplicationSystemTestCase
  def todos_title
    all('ul.todo-list label').map(&:text)
  end

  def completed_todos_title
    all('ul.todo-list li.completed label').map(&:text)
  end

  def selected_filter
    first('footer ul.filters li a.selected').text
  end

  def todos_counter
    first('footer span.todo-count').text
  end

  test "visiting the index" do
    visit root_url

    assert_selector 'h1', text: 'todos'
    assert_equal [
      'Install Ruby',
      'Learn Rails',
      'Learn Stimulus JS'
    ], todos_title
    assert_equal 'All', selected_filter
    assert_equal '2 items left', todos_counter
  end

  test "visiting the index with no todos" do
    Todo.delete_all

    visit root_url

    assert_selector 'h1', text: 'todos'
    assert_empty todos_title
    refute_selector 'section.main'
    refute_selector 'section.footer'
  end

  test "visiting active todos" do
    visit root_url
    assert_selector "h1", text: "todos"

    click_on "Active"

    assert_no_selector 'label', text: 'Install Ruby'
    assert_equal [
      'Learn Rails',
      'Learn Stimulus JS'
    ], todos_title
    assert_equal 'Active', selected_filter
    assert_equal '2 items left', todos_counter
  end

  test "visiting completed todos" do
    visit root_url
    click_on "Completed"

    assert_no_selector 'label', text: 'Learn Rails'
    assert_equal ['Install Ruby'], todos_title
    assert_equal 'Completed', selected_filter
    assert_equal '2 items left', todos_counter
  end

  test "creating a Todo" do
    visit root_url

    fill_in 'todo_title', with: 'Learn Rails test'
    find('#todo_title').native.send_keys(:return)

    assert_selector 'label', text: 'Learn Rails test'
    assert_equal [
      'Install Ruby',
      'Learn Rails',
      'Learn Stimulus JS',
      'Learn Rails test'
    ], todos_title
    assert_equal '3 items left', todos_counter
  end

  test "editing a todo and press enter" do
    visit root_url

    assert_selector 'label', text: 'Learn Rails'
    find('label', text: 'Learn Rails').double_click

    input = first('input.edit')
    input.fill_in with: 'Learn Ruby on Rails'
    input.native.send_keys(:return)

    assert_no_selector 'input.edit'
    assert_selector 'label', text: 'Learn Ruby on Rails'
  end

  test "editing a todo and focus out" do
    visit root_url

    assert_selector 'label', text: 'Learn Rails'
    find('label', text: 'Learn Rails').double_click

    first('input.edit').fill_in with: 'Learn Ruby on Rails'
    # Focus to another element
    find('footer').click

    assert_no_selector 'input.edit'
    assert_selector 'label', text: 'Learn Ruby on Rails'
  end

  test "editing a todo and press escape" do
    visit root_url

    assert_selector 'label', text: 'Learn Rails'
    find('label', text: 'Learn Rails').double_click

    input = first('input.edit')
    input.fill_in with: 'Learn Ruby on Rails'
    input.native.send_keys(:escape)

    assert_no_selector 'input.edit'
    assert_selector 'label', text: 'Learn Rails'
  end

  test "editing a todo with a blank title" do
    visit root_url

    assert_selector 'label', text: 'Learn Rails'
    find('label', text: 'Learn Rails').double_click

    input = first('input.edit')
    input.fill_in with: '   '
    # Focus to another element
    find('footer').click

    assert_no_selector 'input.edit'
    assert_no_selector 'label', text: 'Learn Rails'
    assert_equal '1 item left', todos_counter
  end

  test "marking a todo as completed or not" do
    visit root_url

    assert_equal ['Install Ruby'], completed_todos_title

    first("ul.todo-list li:not(.completed) input.toggle", visible: false).check

    assert_selector 'li.completed', text: 'Learn Rails'
    assert_equal [
      'Install Ruby',
      'Learn Rails'
    ], completed_todos_title
    assert_equal '1 item left', todos_counter

    first("ul.todo-list input.toggle:checked", visible: false).uncheck

    assert_no_selector 'li.completed', text: 'Install Ruby'
    assert_equal ['Learn Rails'], completed_todos_title
    assert_equal '2 items left', todos_counter
  end

  test "toggling all todos" do
    visit root_url
    assert_selector "h1", text: "todos"

    find("label[for='toggle-all']").click

    assert_selector 'li.completed', text: 'Learn Stimulus JS'
    assert_equal [
      'Install Ruby',
      'Learn Rails',
      'Learn Stimulus JS'
    ], completed_todos_title
    assert_equal '0 items left', todos_counter

    find("label[for='toggle-all']").click

    assert_no_selector 'li.completed', text: 'Learn Stimulus JS'
    assert_equal [], completed_todos_title
    assert_equal '3 items left', todos_counter
  end

  test "deleting a todo" do
    visit root_url

    first('ul.todo-list li').hover
    click_button class: 'destroy'

    assert_no_selector 'label', text: 'Install Ruby'
    assert_equal [
      'Learn Rails',
      'Learn Stimulus JS'
    ], todos_title
    assert_equal '2 items left', todos_counter
  end

  test "clearing all completed todos" do
    visit root_url
    assert_selector 'h1', text: 'todos'

    click_on "Clear completed"

    assert_no_selector 'label', text: 'Install Ruby'
    assert_no_selector 'button.clear-completed', text: 'Clear completed'
    assert_equal [
      'Learn Rails',
      'Learn Stimulus JS'
    ], todos_title
  end
end