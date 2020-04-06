require 'test_helper'

class YongHusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @yong_hu = yong_hus(:one)
  end

  test "should get index" do
    get yong_hus_url
    assert_response :success
  end

  test "should get new" do
    get new_yong_hu_url
    assert_response :success
  end

  test "should create yong_hu" do
    assert_difference('YongHu.count') do
      post yong_hus_url, params: { yong_hu: { birth: @yong_hu.birth, phone: @yong_hu.phone, real_name: @yong_hu.real_name, sex: @yong_hu.sex, user_id: @yong_hu.user_id } }
    end

    assert_redirected_to yong_hu_url(YongHu.last)
  end

  test "should show yong_hu" do
    get yong_hu_url(@yong_hu)
    assert_response :success
  end

  test "should get edit" do
    get edit_yong_hu_url(@yong_hu)
    assert_response :success
  end

  test "should update yong_hu" do
    patch yong_hu_url(@yong_hu), params: { yong_hu: { birth: @yong_hu.birth, phone: @yong_hu.phone, real_name: @yong_hu.real_name, sex: @yong_hu.sex, user_id: @yong_hu.user_id } }
    assert_redirected_to yong_hu_url(@yong_hu)
  end

  test "should destroy yong_hu" do
    assert_difference('YongHu.count', -1) do
      delete yong_hu_url(@yong_hu)
    end

    assert_redirected_to yong_hus_url
  end
end
