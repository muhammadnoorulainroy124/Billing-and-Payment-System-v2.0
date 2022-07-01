require 'test_helper'

class FeatruesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @featrue = featrues(:one)
  end

  test "should get index" do
    get featrues_url
    assert_response :success
  end

  test "should get new" do
    get new_featrue_url
    assert_response :success
  end

  test "should create featrue" do
    assert_difference('Featrue.count') do
      post featrues_url, params: { featrue: { code: @featrue.code, name: @featrue.name, unit_price: @featrue.unit_price } }
    end

    assert_redirected_to featrue_url(Featrue.last)
  end

  test "should show featrue" do
    get featrue_url(@featrue)
    assert_response :success
  end

  test "should get edit" do
    get edit_featrue_url(@featrue)
    assert_response :success
  end

  test "should update featrue" do
    patch featrue_url(@featrue), params: { featrue: { code: @featrue.code, name: @featrue.name, unit_price: @featrue.unit_price } }
    assert_redirected_to featrue_url(@featrue)
  end

  test "should destroy featrue" do
    assert_difference('Featrue.count', -1) do
      delete featrue_url(@featrue)
    end

    assert_redirected_to featrues_url
  end
end
