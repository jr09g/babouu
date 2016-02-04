require 'test_helper'

class ReceivedExpenseReportsControllerTest < ActionController::TestCase
  setup do
    @received_expense_report = received_expense_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:received_expense_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create received_expense_report" do
    assert_difference('ReceivedExpenseReport.count') do
      post :create, received_expense_report: {  }
    end

    assert_redirected_to received_expense_report_path(assigns(:received_expense_report))
  end

  test "should show received_expense_report" do
    get :show, id: @received_expense_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @received_expense_report
    assert_response :success
  end

  test "should update received_expense_report" do
    patch :update, id: @received_expense_report, received_expense_report: {  }
    assert_redirected_to received_expense_report_path(assigns(:received_expense_report))
  end

  test "should destroy received_expense_report" do
    assert_difference('ReceivedExpenseReport.count', -1) do
      delete :destroy, id: @received_expense_report
    end

    assert_redirected_to received_expense_reports_path
  end
end
