require 'test_helper'

class EditorsControllerTest < ActionController::TestCase
  setup do
    @editor = editors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:editors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create editor" do
    assert_difference('Editor.count') do
      post :create, :editor => @editor.attributes
    end

    assert_redirected_to editor_path(assigns(:editor))
  end

  test "should show editor" do
    get :show, :id => @editor.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @editor.to_param
    assert_response :success
  end

  test "should update editor" do
    put :update, :id => @editor.to_param, :editor => @editor.attributes
    assert_redirected_to editor_path(assigns(:editor))
  end

  test "should destroy editor" do
    assert_difference('Editor.count', -1) do
      delete :destroy, :id => @editor.to_param
    end

    assert_redirected_to editors_path
  end
end
