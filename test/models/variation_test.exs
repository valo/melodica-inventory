defmodule MelodicaInventory.VariationTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Variation

  @valid_attrs %{}
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
