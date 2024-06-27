require "application_system_test_case"

class PriceListItemsTest < ApplicationSystemTestCase
  setup do
    @price_list_item = price_list_items(:one)
  end

  test "visiting the index" do
    visit price_list_items_url
    assert_selector "h1", text: "Price list items"
  end

  test "should create price list item" do
    visit price_list_items_url
    click_on "New price list item"

    fill_in "Price", with: @price_list_item.price
    fill_in "Product", with: @price_list_item.product_id
    fill_in "User", with: @price_list_item.user_id
    click_on "Create Price list item"

    assert_text "Price list item was successfully created"
    click_on "Back"
  end

  test "should update Price list item" do
    visit price_list_item_url(@price_list_item)
    click_on "Edit this price list item", match: :first

    fill_in "Price", with: @price_list_item.price
    fill_in "Product", with: @price_list_item.product_id
    fill_in "User", with: @price_list_item.user_id
    click_on "Update Price list item"

    assert_text "Price list item was successfully updated"
    click_on "Back"
  end

  test "should destroy Price list item" do
    visit price_list_item_url(@price_list_item)
    click_on "Destroy this price list item", match: :first

    assert_text "Price list item was successfully destroyed"
  end
end
