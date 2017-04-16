defmodule MelodicaInventory.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :user_id, references(:users), null: false
      add :name, :string, null: false
      add :place, :string, null: false
      add :start_date, :date, null: false
      add :end_date, :date, null: false

      timestamps()
    end

    create unique_index(:events, [:user_id])
  end
end
