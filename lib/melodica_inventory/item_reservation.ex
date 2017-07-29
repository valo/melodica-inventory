defmodule MelodicaInventory.ItemReservation do
  use MelodicaInventoryWeb, :model
  alias MelodicaInventory.Item
  alias MelodicaInventory.Event

  schema "item_reservations" do
    belongs_to :event, Event
    belongs_to :item, Item
    field :quantity, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:event_id, :item_id, :quantity])
    |> validate_required([:event_id, :item_id, :quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
  end
end
