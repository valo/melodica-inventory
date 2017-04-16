defmodule MelodicaInventory.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :uuid, :string, null: false
      add :variation_id, references(:variations), null: false
      add :name, :string, null: false
      add :url, :string, null: false

      timestamps()
    end

  end
end
