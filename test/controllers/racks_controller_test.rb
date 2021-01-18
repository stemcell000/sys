require 'test_helper'

class RacksControllerTest < ActionController::TestCase
  setup do
    @rack = racks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:racks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rack" do
    assert_difference('rack.count') do
      post :create, rack: {  }
    end

    assert_redirected_to rack_path(assigns(:rack))
  end

  test "should show rack" do
    get :show, id: @rack
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rack
    assert_response :success
  end

  test "should update rack" do
    patch :update, id: @rack, rack: {  }
    assert_redirected_to rack_path(assigns(:rack))
  end

  test "should destroy rack" do
    assert_difference('rack.count', -1) do
      delete :destroy, id: @rack
    end

    assert_redirected_to racks_path
  end
end
