defmodule EquationSolver do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: EquationSolver.SolverRegistry},
      EquationSolver.TaskCache,
      EquationSolver.SolverSupervisor
    ]

    :ets.new(:solvers_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: EquationSolver.Supervisor]
    Supervisor.start_link(children, opts)
  end


end
