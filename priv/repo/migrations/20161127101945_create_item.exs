defmodule MelodicaInventory.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :variation_id, references(:variations, type: :string), null: false
      add :name, :string, null: false
      add :url, :string, null: false

      timestamps()
    end

  end
end
