defmodule MelodicaInventory.Repo.Migrations.CreateVariation do
  use Ecto.Migration

  def change do
    create table(:variations) do
      add :uuid, :string, null: false
      add :category_id, references(:categories), null: false
      add :name, :string, null: false

      timestamps()
    end

  end
end
