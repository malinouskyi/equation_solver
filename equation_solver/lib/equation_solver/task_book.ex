defmodule EquationSolver.TaskBook do
  @doc """
  Reads a CSV file of buzzwords and their respective point values.

  Returns a list of maps with each map containing the following keys:

    * `:phrase` - the buzzword (phrase)
    * `:points` - the point value
  """
  def read_tasks do
    "../../data/tasks.csv"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ";"))
    |> Enum.map(fn [type, constants] ->
      %{type: type, constants: constants}
    end)
  end
end
