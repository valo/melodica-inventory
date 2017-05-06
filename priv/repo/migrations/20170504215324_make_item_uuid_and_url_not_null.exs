defmodule MelodicaInventory.Repo.Migrations.MakeItemUuidAndUrlNotNull do
  use Ecto.Migration

  def change do
    alter table(:items) do
      modify :url, :string, null: true
      modify :uuid, :string, null: true
    end
  end
end
