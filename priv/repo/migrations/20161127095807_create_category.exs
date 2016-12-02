defmodule MelodicaInventory.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :name, :string, null: false
      add :desc, :string

      timestamps()
    end

  end
end
