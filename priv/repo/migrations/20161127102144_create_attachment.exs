defmodule MelodicaInventory.Repo.Migrations.CreateAttachment do
  use Ecto.Migration

  def change do
    create table(:attachments, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :item_id, references(:items, type: :string), null: false
      add :url, :string, null: false
      add :previews, :map

      timestamps()
    end

  end
end
