defmodule MelodicaInventory.Repo.Migrations.AddLoanTable do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :user_id, references(:users), null: false
      add :item_id, references(:items, type: :string), null: false
      add :quantity, :integer, null: false
      add :fulfilled, :boolean, null: false, default: false

      timestamps
    end

    create table(:returns) do
      add :loan_id, references(:loans), null: false
      add :quantity, :integer, null: false
      add :type, :string, null: false

      timestamps
    end
  end
end
