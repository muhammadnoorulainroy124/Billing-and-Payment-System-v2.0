require "application_system_test_case"

class Admin::PlansTest < ApplicationSystemTestCase
  setup do
    @admin_plan = admin_plans(:one)
  end

  test "visiting the index" do
    visit admin_plans_url
    assert_selector "h1", text: "Admin/Plans"
  end

  test "creating a Plan" do
    visit admin_plans_url
    click_on "New Admin/Plan"

    fill_in "Monthly fee", with: @admin_plan.monthly_fee
    fill_in "Name", with: @admin_plan.name
    click_on "Create Plan"

    assert_text "Plan was successfully created"
    click_on "Back"
  end

  test "updating a Plan" do
    visit admin_plans_url
    click_on "Edit", match: :first

    fill_in "Monthly fee", with: @admin_plan.monthly_fee
    fill_in "Name", with: @admin_plan.name
    click_on "Update Plan"

    assert_text "Plan was successfully updated"
    click_on "Back"
  end

  test "destroying a Plan" do
    visit admin_plans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Plan was successfully destroyed"
  end
end
