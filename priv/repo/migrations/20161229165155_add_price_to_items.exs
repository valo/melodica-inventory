defmodule MelodicaInventory.Repo.Migrations.AddPriceToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :price, :decimal, default: 0, null: false
    end
  end
end
