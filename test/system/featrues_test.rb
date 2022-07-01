require "application_system_test_case"

class FeatruesTest < ApplicationSystemTestCase
  setup do
    @featrue = featrues(:one)
  end

  test "visiting the index" do
    visit featrues_url
    assert_selector "h1", text: "Featrues"
  end

  test "creating a Featrue" do
    visit featrues_url
    click_on "New Featrue"

    fill_in "Code", with: @featrue.code
    fill_in "Name", with: @featrue.name
    fill_in "Unit price", with: @featrue.unit_price
    click_on "Create Featrue"

    assert_text "Featrue was successfully created"
    click_on "Back"
  end

  test "updating a Featrue" do
    visit featrues_url
    click_on "Edit", match: :first

    fill_in "Code", with: @featrue.code
    fill_in "Name", with: @featrue.name
    fill_in "Unit price", with: @featrue.unit_price
    click_on "Update Featrue"

    assert_text "Featrue was successfully updated"
    click_on "Back"
  end

  test "destroying a Featrue" do
    visit featrues_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Featrue was successfully destroyed"
  end
end
