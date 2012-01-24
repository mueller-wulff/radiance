require 'test_helper'

class StitchModulesControllerTest < ActionController::TestCase
  setup do
    @stitch_module = stitch_modules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stitch_modules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stitch_module" do
    assert_difference('StitchModule.count') do
      post :create, :stitch_module => @stitch_module.attributes
    end

    assert_redirected_to stitch_module_path(assigns(:stitch_module))
  end

  test "should show stitch_module" do
    get :show, :id => @stitch_module.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @stitch_module.to_param
    assert_response :success
  end

  test "should update stitch_module" do
    put :update, :id => @stitch_module.to_param, :stitch_module => @stitch_module.attributes
    assert_redirected_to stitch_module_path(assigns(:stitch_module))
  end

  test "should destroy stitch_module" do
    assert_difference('StitchModule.count', -1) do
      delete :destroy, :id => @stitch_module.to_param
    end

    assert_redirected_to stitch_modules_path
  end
end
