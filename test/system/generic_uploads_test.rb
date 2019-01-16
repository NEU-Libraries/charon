require "application_system_test_case"

class GenericUploadsTest < ApplicationSystemTestCase
  setup do
    @generic_upload = generic_uploads(:one)
  end

  test "visiting the index" do
    visit generic_uploads_url
    assert_selector "h1", text: "Generic Uploads"
  end

  test "creating a Generic upload" do
    visit generic_uploads_url
    click_on "New Generic Upload"

    fill_in "Generics", with: @generic_upload.generics
    click_on "Create Generic upload"

    assert_text "Generic upload was successfully created"
    click_on "Back"
  end

  test "updating a Generic upload" do
    visit generic_uploads_url
    click_on "Edit", match: :first

    fill_in "Generics", with: @generic_upload.generics
    click_on "Update Generic upload"

    assert_text "Generic upload was successfully updated"
    click_on "Back"
  end

  test "destroying a Generic upload" do
    visit generic_uploads_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Generic upload was successfully destroyed"
  end
end
