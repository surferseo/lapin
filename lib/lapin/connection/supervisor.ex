defmodule Lapin.Connection.Supervisor do
  @moduledoc """
  Lapin Connections Supervisor
  """
  use Supervisor
  require Logger

  @spec start_link(configuration :: Lapin.config()) :: Supervisor.on_start()
  def start_link(configuration) do
    Supervisor.start_link(__MODULE__, configuration, name: __MODULE__)
  end

  def init(configuration) do
    configuration
    |> Enum.map(fn connection ->
      module = Keyword.get(connection, :module)
      %{id: module, start: {Lapin.Connection, :start_link, [connection, [name: module]]}}
    end)
    |> Supervisor.init(strategy: :one_for_one)
  end
end
