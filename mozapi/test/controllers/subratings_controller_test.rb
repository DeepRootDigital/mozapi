require 'test_helper'

class SubratingsControllerTest < ActionController::TestCase
  setup do
    @subrating = subratings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subratings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subrating" do
    assert_difference('Subrating.count') do
      post :create, subrating: { discription: @subrating.discription, name: @subrating.name, rating_id: @subrating.rating_id, score: @subrating.score }
    end

    assert_redirected_to subrating_path(assigns(:subrating))
  end

  test "should show subrating" do
    get :show, id: @subrating
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subrating
    assert_response :success
  end

  test "should update subrating" do
    patch :update, id: @subrating, subrating: { discription: @subrating.discription, name: @subrating.name, rating_id: @subrating.rating_id, score: @subrating.score }
    assert_redirected_to subrating_path(assigns(:subrating))
  end

  test "should destroy subrating" do
    assert_difference('Subrating.count', -1) do
      delete :destroy, id: @subrating
    end

    assert_redirected_to subratings_path
  end
end
