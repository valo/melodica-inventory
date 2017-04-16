defmodule MelodicaInventory.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use MelodicaInventory.Web, :controller
      use MelodicaInventory.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      use Timex.Ecto.Timestamps

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: MelodicaInventory.Web

      alias MelodicaInventory.Repo
      import Ecto
      import Ecto.Query

      import MelodicaInventory.Web.Router.Helpers
      import MelodicaInventory.Web.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/melodica_inventory/web/templates", namespace: MelodicaInventory.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import MelodicaInventory.Web.Router.Helpers
      import MelodicaInventory.Web.ErrorHelpers
      import MelodicaInventory.Web.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias MelodicaInventory.Repo
      import Ecto
      import Ecto.Query
      import MelodicaInventory.Web.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
