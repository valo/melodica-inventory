defmodule MelodicaInventory.Goods.EventTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Goods.Event

  @valid_attrs %{user_id: 1, name: "Test event", start_date: "2017-07-25", end_date: "2017-07-26", place: "Test place", confirmed: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with end_date before the start_date" do
    attrs = %{@valid_attrs | end_date: "2017-07-24"}
    assert {:date, "End date can't be before the start date"} in errors_on(%Event{}, attrs)
  end
end
