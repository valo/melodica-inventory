defmodule MelodicaInventory.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :uuid, :string, null: false
      add :name, :string, null: false
      add :desc, :string

      timestamps()
    end

    create unique_index(:categories, [:uuid])
  end
end
