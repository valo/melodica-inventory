defmodule MelodicaInventory.Goods.CategoryTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Goods.Category

  @valid_attrs %{name: "Test category", desc: "Test description", uuid: "12345678"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
