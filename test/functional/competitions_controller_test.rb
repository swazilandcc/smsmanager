require 'test_helper'

class CompetitionsControllerTest < ActionController::TestCase
  setup do
    @competition = competitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:competitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create competition" do
    assert_difference('Competition.count') do
      post :create, competition: { description: @competition.description, end_date: @competition.end_date, incorrect_option_message: @competition.incorrect_option_message, keyword: @competition.keyword, keyword_casesensetive: @competition.keyword_casesensetive, name: @competition.name, response_include_serial: @competition.response_include_serial, start_date: @competition.start_date, success_message: @competition.success_message, user_id: @competition.user_id }
    end

    assert_redirected_to competition_path(assigns(:competition))
  end

  test "should show competition" do
    get :show, id: @competition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @competition
    assert_response :success
  end

  test "should update competition" do
    put :update, id: @competition, competition: { description: @competition.description, end_date: @competition.end_date, incorrect_option_message: @competition.incorrect_option_message, keyword: @competition.keyword, keyword_casesensetive: @competition.keyword_casesensetive, name: @competition.name, response_include_serial: @competition.response_include_serial, start_date: @competition.start_date, success_message: @competition.success_message, user_id: @competition.user_id }
    assert_redirected_to competition_path(assigns(:competition))
  end

  test "should destroy competition" do
    assert_difference('Competition.count', -1) do
      delete :destroy, id: @competition
    end

    assert_redirected_to competitions_path
  end
end
