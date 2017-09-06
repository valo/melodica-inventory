defmodule MelodicaInventory.Accounts.CustomerAuth do
  alias MelodicaInventory.Repo
  alias MelodicaInventory.Accounts.Customer

  def find_or_create!(
    %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: email, name: name, image: image_url
  }}) do
    Customer.changeset(%Customer{}, %{
      email: email,
      name: name,
      image_url: image_url
    })
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :email)
  end
end
