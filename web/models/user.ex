defmodule MelodicaInventory.User do
  use MelodicaInventory.Web, :model
  
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :image_url, :string

    timestamps
  end
end
