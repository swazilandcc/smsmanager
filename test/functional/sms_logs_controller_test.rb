require 'test_helper'

class SmsLogsControllerTest < ActionController::TestCase
  setup do
    @sms_log = sms_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sms_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sms_log" do
    assert_difference('SmsLog.count') do
      post :create, sms_log: { cell_number: @sms_log.cell_number, message: @sms_log.message, status: @sms_log.status, user_id: @sms_log.user_id }
    end

    assert_redirected_to sms_log_path(assigns(:sms_log))
  end

  test "should show sms_log" do
    get :show, id: @sms_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sms_log
    assert_response :success
  end

  test "should update sms_log" do
    put :update, id: @sms_log, sms_log: { cell_number: @sms_log.cell_number, message: @sms_log.message, status: @sms_log.status, user_id: @sms_log.user_id }
    assert_redirected_to sms_log_path(assigns(:sms_log))
  end

  test "should destroy sms_log" do
    assert_difference('SmsLog.count', -1) do
      delete :destroy, id: @sms_log
    end

    assert_redirected_to sms_logs_path
  end
end
