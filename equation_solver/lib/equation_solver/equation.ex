defmodule EquationSolver.Equation do

  alias EquationSolver.{Solution}

  @enforce_keys [:type, :constants]
  defstruct [:type, :constants, :solution, :marked_by ]

  alias __MODULE__


  @doc """
  Creates a square from the given `phrase` and `points`.
  """

  def new(type, constants) do
    %Equation{type: type, constants: constants}
  end

  @spec new(any, any, any) :: EquationSolver.Equation.t()
  def new(type, constants, solution) do
    %Equation{type: type, constants: constants, solution: solution}
  end

  @doc """
  Creates a square from the given map with `:phrase` and `:points` keys.
  """
  def from_task(%{type: type, constants: constants}) do

    solution = EquationSolver.Solution.new(type, constants)

    Equation.new(type, constants, solution)

  end

  def from_equation( equation ) do
    solution = Solution.new(equation.type, equation.constants)

    %Equation{equation | solution: solution}
  end
end
