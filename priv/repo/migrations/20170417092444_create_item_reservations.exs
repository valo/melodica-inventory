defmodule MelodicaInventory.Repo.Migrations.CreateItemReservations do
  use Ecto.Migration

  def change do
    create table(:item_reservations) do
      add :event_id, references(:events), null: false
      add :item_id, references(:items), null: false
      add :quantity, :integer, null: false

      timestamps()
    end

    create index(:item_reservations, [:event_id])
    create index(:item_reservations, [:item_id])
  end
end
