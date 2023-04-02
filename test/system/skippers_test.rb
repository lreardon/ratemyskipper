require "application_system_test_case"

class SkippersTest < ApplicationSystemTestCase
  setup do
    @skipper = skippers(:one)
  end

  test "visiting the index" do
    visit skippers_url
    assert_selector "h1", text: "Skippers"
  end

  test "should create skipper" do
    visit skippers_url
    click_on "New skipper"

    click_on "Create Skipper"

    assert_text "Skipper was successfully created"
    click_on "Back"
  end

  test "should update Skipper" do
    visit skipper_url(@skipper)
    click_on "Edit this skipper", match: :first

    click_on "Update Skipper"

    assert_text "Skipper was successfully updated"
    click_on "Back"
  end

  test "should destroy Skipper" do
    visit skipper_url(@skipper)
    click_on "Destroy this skipper", match: :first

    assert_text "Skipper was successfully destroyed"
  end
end
