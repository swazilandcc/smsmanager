require 'test_helper'

class BulkMessageTemplatesControllerTest < ActionController::TestCase
  setup do
    @bulk_message_template = bulk_message_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bulk_message_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bulk_message_template" do
    assert_difference('BulkMessageTemplate.count') do
      post :create, bulk_message_template: { message: @bulk_message_template.message, name: @bulk_message_template.name }
    end

    assert_redirected_to bulk_message_template_path(assigns(:bulk_message_template))
  end

  test "should show bulk_message_template" do
    get :show, id: @bulk_message_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bulk_message_template
    assert_response :success
  end

  test "should update bulk_message_template" do
    put :update, id: @bulk_message_template, bulk_message_template: { message: @bulk_message_template.message, name: @bulk_message_template.name }
    assert_redirected_to bulk_message_template_path(assigns(:bulk_message_template))
  end

  test "should destroy bulk_message_template" do
    assert_difference('BulkMessageTemplate.count', -1) do
      delete :destroy, id: @bulk_message_template
    end

    assert_redirected_to bulk_message_templates_path
  end
end
