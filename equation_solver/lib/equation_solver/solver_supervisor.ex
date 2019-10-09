defmodule EquationSolver.SolverSupervisor do
  @moduledoc """
  A supervisor that starts `GameServer` processes dynamically.
  """

  use DynamicSupervisor

  alias EquationSolver.SolverServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a `GameServer` process and supervises it.
  """
  def start_solver(solver_name) do
    child_spec = %{
      id: SolverServer,
      start: {SolverServer, :start_link, [solver_name]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Terminates the `GameServer` process normally. It won't be restarted.
  """
  def stop_solver(solver_name) do
    :ets.delete(:solvers_table, solver_name)

    child_pid = SolverServer.solver_pid(solver_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
