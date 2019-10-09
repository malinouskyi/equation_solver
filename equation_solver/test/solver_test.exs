defmodule SolverTest do
  use ExUnit.Case, async: true

  doctest EquationSolver.Solver

  alias EquationSolver.{Solver, Equation, SolverDisplay, User}

  setup do
    user = User.new("Dima")

    [
      # Grid of squares with preset buzzwords (letters)
      # so the tests are consistent.
      equations: [
        sq("linear", "x+5-3+x=6g+x-2"),
        #sq("quadratic", "a = 1, b = 3, c = 5")
        # sq("other", "?")
      ],

      new_equations: [
        sq("quadratic", "a = 10, b = 33, c = 5000")
      ],
      user: user
    ]

  end

  # describe "creating a solver" do
  #   test "with a list of tasks" do
  #     solver = Solver.new(TaskBook.read_tasks())
  #     assert_solver_size solver, 2
  #     SolverDisplay.display(solver)
  #   end

  #   defp assert_solver_size(solver, size) do
  #     row_count = Enum.count(solver.equations)
  #     assert row_count == size
  #   end

  # end

  # describe "run solver when fully solve" do
  #   test "run solver when fully solve",
  #     context do

  #     solver =
  #       new_solver(context.equations)
  #       |> Solver.run_solver()

  #     SolverDisplay.display(solver)
  #     # IO.inspect(solver)

  #     assert 1 == 1
  #   end

  # end

  describe "Run Solver for test Solution " do
    test "solve new equation",
      context do

      solver = Solver.new(context.equations)

      solver
      |> Solver.run_solver()
      |> Solver.solve(context.new_equations)

      SolverDisplay.display(solver)

      assert 1==1
    end

  end


  defp sq(type, constants) do
    Equation.new(type, constants)
  end

  # defp new_solver(equations) do
  #   %Solver{equations: equations}
  # end
end
