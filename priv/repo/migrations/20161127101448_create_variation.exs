defmodule MelodicaInventory.Repo.Migrations.CreateVariation do
  use Ecto.Migration

  def change do
    create table(:variations, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :category_id, references(:categories, type: :string), null: false
      add :name, :string, null: false

      timestamps()
    end

  end
end
