defmodule MelodicaInventory.Repo.Migrations.AddQuantityToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :quantity, :integer, default: 0, null: false
    end
  end
end
