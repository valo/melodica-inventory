defmodule MelodicaInventory.UserAuth do
  alias MelodicaInventory.Repo
  alias MelodicaInventory.User

  def find_or_create(
    %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: email, first_name: first_name, last_name: last_name, image: image_url
      }}) do
    if email_allowed?(email) do
      {:ok, find_or_create_db_user(%{email: email, first_name: first_name, last_name: last_name, image_url: image_url}) }
    else
      {:error, "Authentication failed"}
    end
  end

  defp find_or_create_db_user(%{email: email} = user_attrs) do
    case Repo.get_by(User, email: email) do
      db_user ->
        User.changeset(db_user, user_attrs)
        |> Repo.update!
      nil ->
        User.changeset(%User{}, user_attrs)
        |> Repo.insert!
    end
  end

  defp email_allowed?(email) do
    String.ends_with?(email, "@melodica-events.com") or String.ends_with?(email, "@melodica-corporate.com")
  end
end
