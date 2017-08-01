defmodule MelodicaInventory.Web.Admin.EventController do
  @moduledoc false

  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.{Event, User}

  def edit(conn, %{"id" => id}) do
    changeset =
    Event
    |> Repo.get!(id)
    |> Event.changeset

    render conn, "edit.html", changeset: changeset, users: Repo.all(User)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    changeset =
      Event
      |> Repo.get!(id)
      |> Event.changeset(event_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    Repo.delete!(event)

    redirect(conn, to: event_path(conn, :index))
  end
end
