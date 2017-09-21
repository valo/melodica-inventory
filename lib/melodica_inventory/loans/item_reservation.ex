defmodule MelodicaInventory.Loans.ItemReservation do
  @moduledoc false

  use MelodicaInventoryWeb, :model
  alias MelodicaInventory.Goods.{Item, Event}
  alias MelodicaInventory.Loans.ItemReservation
  alias MelodicaInventory.Repo

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

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:event_id, :item_id, :quantity])
    |> validate_required([:event_id, :item_id, :quantity])
    |> validate_number(:quantity, greater_than: 0)
    |> validate_available_quantity
  end

  defp validate_available_quantity(changeset) do
    # 1. Get all events where the item is reserved.
    # 2. Get all events from the previous events that overlap with the current event.
    # 3. Build a list of tuples with start date and qunatity with +-.
    # 4. Sort the list of tuples.
    # 5. Sum the quantities until the current event start date.
    # 6. Check if there are available items after start date of the current event.
    # 7. Continue summing and checking until the end date of the current event.
    current_event = Repo.get(Event, changeset.data.event_id)
    item_quantity = Repo.get(Item, changeset.changes[:item_id]).quantity
    query = from ir in "item_reservations",
      join: e in Event, where: ir.event_id == e.id,
      where: ir.item_id == ^changeset.changes[:item_id],
      where: (e.start_date >= ^current_event.start_date and e.start_date <= ^current_event.end_date) or
        (e.end_date >= ^current_event.start_date and e.end_date <= ^current_event.end_date),
      select: ir.id

    Repo.all(query)
    |> build_list_of_dates_and_quantities(current_event, item_quantity)
    |> Enum.sort(&compare_dates(elem(&1, 0), elem(&2, 0)))
    |> check_availability(current_event, item_quantity, changeset)
  end

  defp compare_dates(first_date, second_date) do
    if (Date.compare(first_date, second_date) == :lt), do: true, else: false
  end

  defp build_list_of_dates_and_quantities(item_reservation_ids, current_event, item_quantity) do
    Enum.reduce(item_reservation_ids, [], fn(item_reservation_id, acc) ->
      item_reservation = Repo.get(ItemReservation, item_reservation_id)
      item_reservation = Repo.preload(item_reservation, :event)
      acc = [{item_reservation.event.start_date, item_reservation.quantity} | acc]
      acc = [{item_reservation.event.end_date, -item_reservation.quantity} | acc]
    end)
  end

  defp check_availability(list_of_dates_and_quantities, current_event, item_quantity, changeset) do
    quantity_withou_current_reservation = item_quantity - changeset.changes[:quantity]
    qunatity = Enum.reduce_while(list_of_dates_and_quantities, quantity_withou_current_reservation, fn(date_and_quantity, quantity) ->
      cond do
        quantity < 0 ->
          IO.puts("LOGGER: Branch 1")
          {:halt, quantity}
        elem(date_and_quantity, 0) >= current_event.start_date or
          elem(date_and_quantity, 0) <= current_event.end_date ->
            quantity = quantity - elem(date_and_quantity, 1)
            IO.puts("LOGGER quantity: #{quantity}")
            if quantity >= 0 do
              IO.puts("LOGGER: Branch 2")
              {:cont, quantity}
            else
              IO.puts("LOGGER: Branch 3")
              {:halt, quantity}
            end
        true ->
          IO.puts("LOGGER: Branch 4")
          {:cont, quantity - elem(date_and_quantity, 1)}
      end
    end)

    if qunatity >= 0 do
      changeset
    else
      Ecto.Changeset.add_error(changeset, :quantity, quantity_error_message(qunatity + changeset.changes[:quantity]))
    end
  end

  defp quantity_error_message(available_items) do
    case available_items > 0 do
      true -> "Not enough items available. You can reserve at most #{available_items}"
      false -> "Not enough items available."
    end
  end
end
