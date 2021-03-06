defmodule MelodicaInventory.Goods.VariationTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Goods.Variation

  @valid_attrs %{name: "Test variation", category_id: 1, uuid: "12345678"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Variation.changeset(%Variation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Variation.changeset(%Variation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
