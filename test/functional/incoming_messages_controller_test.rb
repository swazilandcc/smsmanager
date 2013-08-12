require 'test_helper'

class IncomingMessagesControllerTest < ActionController::TestCase
  setup do
    @incoming_message = incoming_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incoming_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incoming_message" do
    assert_difference('IncomingMessage.count') do
      post :create, incoming_message: { competition_id: @incoming_message.competition_id, devotional_id: @incoming_message.devotional_id, extra_text: @incoming_message.extra_text, keyword: @incoming_message.keyword, matched_to_competition: @incoming_message.matched_to_competition, matched_to_devotional: @incoming_message.matched_to_devotional, option: @incoming_message.option, reply_message: @incoming_message.reply_message, reply_sent: @incoming_message.reply_sent, reply_sent_date_time: @incoming_message.reply_sent_date_time, sender: @incoming_message.sender }
    end

    assert_redirected_to incoming_message_path(assigns(:incoming_message))
  end

  test "should show incoming_message" do
    get :show, id: @incoming_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @incoming_message
    assert_response :success
  end

  test "should update incoming_message" do
    put :update, id: @incoming_message, incoming_message: { competition_id: @incoming_message.competition_id, devotional_id: @incoming_message.devotional_id, extra_text: @incoming_message.extra_text, keyword: @incoming_message.keyword, matched_to_competition: @incoming_message.matched_to_competition, matched_to_devotional: @incoming_message.matched_to_devotional, option: @incoming_message.option, reply_message: @incoming_message.reply_message, reply_sent: @incoming_message.reply_sent, reply_sent_date_time: @incoming_message.reply_sent_date_time, sender: @incoming_message.sender }
    assert_redirected_to incoming_message_path(assigns(:incoming_message))
  end

  test "should destroy incoming_message" do
    assert_difference('IncomingMessage.count', -1) do
      delete :destroy, id: @incoming_message
    end

    assert_redirected_to incoming_messages_path
  end
end
