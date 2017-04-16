defmodule MelodicaInventory.Repo.Migrations.CreateAttachment do
  use Ecto.Migration

  def change do
    create table(:attachments) do
      add :uuid, :string, null: false
      add :item_id, references(:items), null: false
      add :url, :string, null: false, size: 1024
      add :previews, :map

      timestamps()
    end

  end
end
