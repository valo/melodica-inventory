defmodule MelodicaInventory.Repo.Migrations.CreateMelodicaInventory.MelodicaInventory.Image do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :item_id, references(:items)
      add :public_id, :string

      timestamps()
    end

  end
end
