defmodule :"Elixir.MelodicaInventory.Repo.Migrations.Make-references-delete-all" do
  use Ecto.Migration

  def change do
    drop constraint(:loans, :loans_item_id_fkey)
    alter table(:loans) do
      modify :item_id, references(:items, on_delete: :delete_all)
    end

    drop constraint(:item_reservations, :item_reservations_item_id_fkey)
    alter table(:item_reservations) do
      modify :item_id, references(:items, on_delete: :delete_all)
    end

    drop constraint(:attachments, :attachments_item_id_fkey)
    alter table(:attachments) do
      modify :item_id, references(:items, on_delete: :delete_all)
    end

    drop constraint(:images, :images_item_id_fkey)
    alter table(:images) do
      modify :item_id, references(:items, on_delete: :delete_all)
    end

    drop constraint(:items, :items_variation_id_fkey)
    alter table(:items) do
      modify :variation_id, references(:variations, on_delete: :delete_all)
    end
  end
end
