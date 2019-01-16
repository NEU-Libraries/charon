require 'test_helper'

class GenericUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @generic_upload = generic_uploads(:one)
  end

  test "should get index" do
    get generic_uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_generic_upload_url
    assert_response :success
  end

  test "should create generic_upload" do
    assert_difference('GenericUpload.count') do
      post generic_uploads_url, params: { generic_upload: { generics: @generic_upload.generics } }
    end

    assert_redirected_to generic_upload_url(GenericUpload.last)
  end

  test "should show generic_upload" do
    get generic_upload_url(@generic_upload)
    assert_response :success
  end

  test "should get edit" do
    get edit_generic_upload_url(@generic_upload)
    assert_response :success
  end

  test "should update generic_upload" do
    patch generic_upload_url(@generic_upload), params: { generic_upload: { generics: @generic_upload.generics } }
    assert_redirected_to generic_upload_url(@generic_upload)
  end

  test "should destroy generic_upload" do
    assert_difference('GenericUpload.count', -1) do
      delete generic_upload_url(@generic_upload)
    end

    assert_redirected_to generic_uploads_url
  end
end
