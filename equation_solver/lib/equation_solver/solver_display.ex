defmodule EquationSolver.SolverDisplay do
  @moduledoc """
  Displays a textual representation of a solver.
  """

  alias IO.ANSI

  @doc """
  Prints a textual representation of the game to standard out.
  """
  def display(solver) do
    print_equations(solver.equations)
    # print_solutions(solver.solutions)
  end

  defp print_equations(equations) do
    IO.write("\n")
    Enum.each(equations, fn row_equations ->
      print_row(row_equations)
    end)
  end

  defp print_row(row_equations) do
    str = if (!row_equations.constants) do
      "Equation is nil"
    else
      (row_equations.constants <> " - Solution: #{inspect row_equations.solution} " )
    end
    str
    |> ANSI.format(true)
    |> IO.write()
    IO.write("\n")

  end

  # defp print_solutions(solutions) do
  #   IO.write("---------\n")
  #   Enum.each(solutions, fn row_solutions ->
  #     row_solutions
  #     |> ANSI.format(true)
  #     |> IO.write()
  #   end)
  # end

end
