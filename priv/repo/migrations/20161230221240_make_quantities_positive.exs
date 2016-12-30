defmodule MelodicaInventory.Repo.Migrations.MakeQuantitiesPositive do
  use Ecto.Migration

  def change do
    create constraint(:items, "quantity_must_be_positive", check: "quantity >= 0", )
    create constraint(:loans, "quantity_must_be_positive", check: "quantity >= 0", )
    create constraint(:returns, "quantity_must_be_positive", check: "quantity >= 0", )
  end
end
