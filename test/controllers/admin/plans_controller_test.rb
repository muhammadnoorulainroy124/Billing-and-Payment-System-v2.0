require 'test_helper'

class Admin::PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_plan = admin_plans(:one)
  end

  test "should get index" do
    get admin_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_plan_url
    assert_response :success
  end

  test "should create admin_plan" do
    assert_difference('Admin::Plan.count') do
      post admin_plans_url, params: { admin_plan: { monthly_fee: @admin_plan.monthly_fee, name: @admin_plan.name } }
    end

    assert_redirected_to admin_plan_url(Admin::Plan.last)
  end

  test "should show admin_plan" do
    get admin_plan_url(@admin_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_plan_url(@admin_plan)
    assert_response :success
  end

  test "should update admin_plan" do
    patch admin_plan_url(@admin_plan), params: { admin_plan: { monthly_fee: @admin_plan.monthly_fee, name: @admin_plan.name } }
    assert_redirected_to admin_plan_url(@admin_plan)
  end

  test "should destroy admin_plan" do
    assert_difference('Admin::Plan.count', -1) do
      delete admin_plan_url(@admin_plan)
    end

    assert_redirected_to admin_plans_url
  end
end
