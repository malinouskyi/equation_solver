defmodule EquationSolver.User do

  @enforce_keys [:name]
  defstruct [:name]

  @doc """
  Creates a user with the given `name`.
  """
  def new(name) do
    %EquationSolver.User{name: name}
  end
end
