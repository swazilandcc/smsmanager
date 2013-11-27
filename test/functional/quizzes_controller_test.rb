require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  setup do
    @quiz = quizzes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quizzes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quiz" do
    assert_difference('Quiz.count') do
      post :create, quiz: { correct_answer: @quiz.correct_answer, enabled: @quiz.enabled, incorrect_answer: @quiz.incorrect_answer, keyword: @quiz.keyword, next_on_incorrect: @quiz.next_on_incorrect, welcome_message: @quiz.welcome_message }
    end

    assert_redirected_to quiz_path(assigns(:quiz))
  end

  test "should show quiz" do
    get :show, id: @quiz
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quiz
    assert_response :success
  end

  test "should update quiz" do
    put :update, id: @quiz, quiz: { correct_answer: @quiz.correct_answer, enabled: @quiz.enabled, incorrect_answer: @quiz.incorrect_answer, keyword: @quiz.keyword, next_on_incorrect: @quiz.next_on_incorrect, welcome_message: @quiz.welcome_message }
    assert_redirected_to quiz_path(assigns(:quiz))
  end

  test "should destroy quiz" do
    assert_difference('Quiz.count', -1) do
      delete :destroy, id: @quiz
    end

    assert_redirected_to quizzes_path
  end
end
