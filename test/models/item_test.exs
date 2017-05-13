defmodule MelodicaInventory.ItemTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Item
  import MelodicaInventory.Factory

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

  test "total_quantity returns the quantity of the item" do
    item = insert(:item, quantity: 20)

    item = item
    |> Repo.preload(:loans)

    assert Item.total_quantity(item) == item.quantity
  end

  test "total_quantity includes the loans that are not filfilled" do
    item = insert(:item, quantity: 20)
    loan = insert(:loan, item: item, quantity: 10, fulfilled: false)
    insert(:loan, item: item, quantity: 10, fulfilled: true)

    item = item
    |> Repo.preload(:loans)

    assert Item.total_quantity(item) == item.quantity + loan.quantity
  end
end
