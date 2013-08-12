require 'test_helper'

class SendBulkMessagesControllerTest < ActionController::TestCase
  setup do
    @send_bulk_message = send_bulk_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:send_bulk_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create send_bulk_message" do
    assert_difference('SendBulkMessage.count') do
      post :create, send_bulk_message: { group_id: @send_bulk_message.group_id, message: @send_bulk_message.message, status: @send_bulk_message.status, user_id: @send_bulk_message.user_id }
    end

    assert_redirected_to send_bulk_message_path(assigns(:send_bulk_message))
  end

  test "should show send_bulk_message" do
    get :show, id: @send_bulk_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @send_bulk_message
    assert_response :success
  end

  test "should update send_bulk_message" do
    put :update, id: @send_bulk_message, send_bulk_message: { group_id: @send_bulk_message.group_id, message: @send_bulk_message.message, status: @send_bulk_message.status, user_id: @send_bulk_message.user_id }
    assert_redirected_to send_bulk_message_path(assigns(:send_bulk_message))
  end

  test "should destroy send_bulk_message" do
    assert_difference('SendBulkMessage.count', -1) do
      delete :destroy, id: @send_bulk_message
    end

    assert_redirected_to send_bulk_messages_path
  end
end
