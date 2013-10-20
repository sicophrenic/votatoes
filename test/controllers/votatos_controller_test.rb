require 'test_helper'

class VotatosControllerTest < ActionController::TestCase
  setup do
    @votato = votatos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:votatos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create votato" do
    assert_difference('Votato.count') do
      post :create, votato: {  }
    end

    assert_redirected_to votato_path(assigns(:votato))
  end

  test "should show votato" do
    get :show, id: @votato
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @votato
    assert_response :success
  end

  test "should update votato" do
    patch :update, id: @votato, votato: {  }
    assert_redirected_to votato_path(assigns(:votato))
  end

  test "should destroy votato" do
    assert_difference('Votato.count', -1) do
      delete :destroy, id: @votato
    end

    assert_redirected_to votatos_path
  end
end
