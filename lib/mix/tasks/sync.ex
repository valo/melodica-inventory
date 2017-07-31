defmodule Mix.Tasks.Sync do
  @moduledoc false

  use Mix.Task
  alias MelodicaInventory.SyncInventory

  def run(_args) do
    Application.ensure_all_started(:melodica_inventory)
    SyncInventory.sync()
  end
end
