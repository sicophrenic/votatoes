require 'test_helper'

class PlantationsControllerTest < ActionController::TestCase
  setup do
    @plantation = plantations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plantations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plantation" do
    assert_difference('Plantation.count') do
      post :create, plantation: {  }
    end

    assert_redirected_to plantation_path(assigns(:plantation))
  end

  test "should show plantation" do
    get :show, id: @plantation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plantation
    assert_response :success
  end

  test "should update plantation" do
    patch :update, id: @plantation, plantation: {  }
    assert_redirected_to plantation_path(assigns(:plantation))
  end

  test "should destroy plantation" do
    assert_difference('Plantation.count', -1) do
      delete :destroy, id: @plantation
    end

    assert_redirected_to plantations_path
  end
end
