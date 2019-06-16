defmodule :"Elixir.MelodicaInventory.Repo.Migrations.Add-archive-to-events" do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add(:archived_at, :utc_datetime, default: nil)
    end
  end
end
