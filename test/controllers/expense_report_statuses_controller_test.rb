require 'test_helper'

class ExpenseReportStatusesControllerTest < ActionController::TestCase
  setup do
    @expense_report_status = expense_report_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expense_report_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expense_report_status" do
    assert_difference('ExpenseReportStatus.count') do
      post :create, expense_report_status: {  }
    end

    assert_redirected_to expense_report_status_path(assigns(:expense_report_status))
  end

  test "should show expense_report_status" do
    get :show, id: @expense_report_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expense_report_status
    assert_response :success
  end

  test "should update expense_report_status" do
    patch :update, id: @expense_report_status, expense_report_status: {  }
    assert_redirected_to expense_report_status_path(assigns(:expense_report_status))
  end

  test "should destroy expense_report_status" do
    assert_difference('ExpenseReportStatus.count', -1) do
      delete :destroy, id: @expense_report_status
    end

    assert_redirected_to expense_report_statuses_path
  end
end
