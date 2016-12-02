defmodule MelodicaInventory.AttachmentTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Attachment

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Attachment.changeset(%Attachment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Attachment.changeset(%Attachment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
