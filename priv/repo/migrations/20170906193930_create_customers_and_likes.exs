defmodule MelodicaInventory.Repo.Migrations.CreateCustomersAndLikes do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :email, :string, null: false
      add :name, :string, null: false
      add :image_url, :string, null: false
      add :approved, :boolean, null: false, default: false

      timestamps()
    end
    create index(:customers, :email, unique: true)

    create table(:customer_likes) do
      add :customer_id, references(:customers), null: false
      add :item_id, references(:items), null: false

      timestamps()
    end

    create index(:customer_likes, [:customer_id, :item_id], unique: true)
  end
end
