defmodule MelodicaInventory.ItemTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Item

  @valid_attrs %{name: "Test item", url: "http://example.com", quantity: 1, price: 1, variation_id: 1, uuid: "12345678"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
