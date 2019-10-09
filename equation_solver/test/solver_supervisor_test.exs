defmodule SolverSupervisorTest do
  use ExUnit.Case, async: true

  doctest EquationSolver.SolverSupervisor

  alias EquationSolver.{SolverSupervisor, SolverServer}

  describe "start_solver" do
    test "spawns a solver server process" do
      solver_name = "solver-#{:rand.uniform(1000)}"

      assert {:ok, _pid} = SolverSupervisor.start_solver(solver_name)

      via = SolverServer.via_tuple(solver_name)

      assert GenServer.whereis(via) |> Process.alive?()
    end

    test "returns an error if solver is already started" do
      solver_name = "solver-#{:rand.uniform(1000)}"

      assert {:ok, pid} = SolverSupervisor.start_solver(solver_name)

      assert {:error, {:already_started, ^pid}} =
        SolverSupervisor.start_solver(solver_name)
    end
  end

  # describe "stop_solver" do
  #   test "terminates the process normally" do
  #     solver_name = "solver-#{:rand.uniform(1000)}"

  #     {:ok, _pid} = SolverSupervisor.start_solver(solver_name)

  #     via = SolverServer.via_tuple(solver_name)

  #     assert :ok = SolverSupervisor.start_solver(solver_name)

  #     refute GenServer.whereis(via)
  #   end
  # end

end
