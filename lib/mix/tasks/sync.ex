defmodule Mix.Tasks.Sync do
  use Mix.Task

  def run(_args) do
    Application.ensure_all_started(:melodica_inventory)
    MelodicaInventory.SyncInventory.sync()
  end
end
