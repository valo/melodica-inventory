defmodule MelodicaInventory.Web.Admin.LoanController do
  @moduledoc false

  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.{Loan, User}

  def index(conn, params) do
    users =
      User
      |> Repo.all()
      |> Enum.map(&user_for_select/1)

    loans =
      Loan
      |> where([l], not l.fulfilled)
      |> Repo.all
      |> Repo.preload([:item, :user])
      |> apply_filters(params["filters"])

    render conn, "index.html", loans: loans, users: users
  end

  defp apply_filters(loans, nil), do: loans

  defp apply_filters(loans, %{"name" => name, "user_id" => user_id}) do
    loans
    |> Enum.filter(fn loan ->
      (name == "" ||
      String.contains?(loan.item.name, name)) &&
      (user_id == "" || loan.user_id == String.to_integer(user_id))
    end)
  end

  defp user_for_select(user) do
    {"#{user.first_name} #{user.last_name}", user.id}
  end
end
