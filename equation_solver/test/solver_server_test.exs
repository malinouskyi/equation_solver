defmodule SolverServerTest do
  use ExUnit.Case, async: true

  doctest EquationSolver.SolverServer

  alias EquationSolver.{SolverServer, Equation}

  setup do
    [
      new_equations: [
        sq("linear", "2x+30=12")
      ]
    ]
  end


  test "spawning a solver server process" do
    solver_name = generate_solver_name()
    assert {:ok, _pid} = SolverServer.start_link(solver_name)
  end

  test "a solver process is registered under a unique name" do
    solver_name = generate_solver_name()

    assert {:ok, _pid} = SolverServer.start_link(solver_name)

    assert {:error, _reason} = SolverServer.start_link(solver_name)
  end

  test "getting a summary" do
    solver_name = generate_solver_name()

    {:ok, _pid} = SolverServer.start_link(solver_name)

    summary = SolverServer.summary(solver_name)

    assert Enum.count(summary.equations) == 2

  end

  test "проверить функции решателя" do
    solver_name = generate_solver_name()

    {:ok, _pid} = SolverServer.start_link(solver_name)

    summary = SolverServer.solve_new_equation(solver_name, "2x+30=12", "linear")

   assert -9.0 == summary.equations.solution.answer
  end

  # describe "solver_pid" do
  #   test "returns a PID if it has been registered" do
  #     solver_name = generate_solver_name()

  #     {:ok, pid} = SolverServer.start_link(solver_name)

  #     assert ^pid = SolverServer.solver_pid(solver_name)
  #   end

  #   test "returns nil if the solver does not exist" do
  #     refute SolverServer.solver_pid("nonexistent-solver")
  #   end
  # end

  defp generate_solver_name do
    "solver-#{:rand.uniform(1_000_000)}"
  end

  defp sq(type, constants) do
    Equation.new(type, constants)
  end

end
