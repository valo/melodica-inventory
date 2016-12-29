defmodule MelodicaInventory.UserAuth do
  alias MelodicaInventory.Repo
  alias MelodicaInventory.User

  def find_or_create(
    %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: email, first_name: first_name, last_name: last_name, image: image_url
      }}) do
    if String.ends_with?(email, "@melodica-events.com") do
      {:ok, find_or_create_db_user(%User{email: email, first_name: first_name, last_name: last_name, image_url: image_url, admin: true}) }
    else
      {:ok, find_or_create_db_user(%User{email: email, first_name: first_name, last_name: last_name, image_url: image_url, admin: false}) }
      # {:error, "Authentication failed"}
    end
  end

  defp find_or_create_db_user(%User{email: email} = user) do
    Repo.get_by(User, email: email) || Repo.insert!(user)
  end
end
