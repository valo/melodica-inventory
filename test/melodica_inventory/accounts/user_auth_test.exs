defmodule MelodicaInventory.Accounts.UserAuthTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Accounts.UserAuth
  alias MelodicaInventory.Accounts.User

  import MelodicaInventory.Factory

  test "should return authentication error if the email is not allowed" do
    {:error, _} = UserAuth.find_or_create(auth_hash(email: "test@gmail.com"))
  end

  test "should create a new user if the email is allowed" do
    params = auth_hash(email: "test@melodica-events.com")
    {:ok, %User{}} = UserAuth.find_or_create(params)
  end

  test "should update the user if the email is allowed" do
    user = insert(:user, email: "test@melodica-events.com", first_name: "Test", last_name: "Test")
    params = auth_hash(email: "test@melodica-events.com", first_name: "Joe", last_name: "Dow", image: "http://test.com")
    {:ok, %User{first_name: "Joe", last_name: "Dow"}} = UserAuth.find_or_create(params)

    assert Repo.get(User, user.id).first_name == "Joe"
    assert Repo.get(User, user.id).last_name == "Dow"
  end

  defp auth_hash(attrs) do
    %Ueberauth.Auth{
      info: struct!(%Ueberauth.Auth.Info{
        first_name: "Joe",
        last_name: "Dow",
        image: "http://test.com"
      }, attrs)
    }
  end
end
