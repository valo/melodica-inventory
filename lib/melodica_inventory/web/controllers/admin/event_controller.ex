defmodule MelodicaInventory.Web.Admin.EventController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Event
  alias MelodicaInventory.User

  def edit(conn, %{"id" => id}) do
    changeset = Repo.get!(Event, id)
    |> Event.changeset

    render conn, "edit.html", changeset: changeset, users: Repo.all(User)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    changeset = Repo.get!(Event, id)
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

    redirect(conn, to: admin_event_path(conn, :index))
  end

  def new(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _) do
    changeset = Event.changeset(%Event{user_id: current_user.id})

    render(conn, "new.html", changeset: changeset, users: Repo.all(User))
  end

  def create(conn, %{"event" => event_params}) do
    changeset = Event.changeset(%Event{}, event_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, users: Repo.all(User))
    end
  end
end
