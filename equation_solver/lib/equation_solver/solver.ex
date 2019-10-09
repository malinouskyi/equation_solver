defmodule EquationSolver.Solver do
  @moduledoc """
  Решатель, который содержит основные функции логики решения уравнения

    ##Logger пишет в файл ../log/error.log
  """

  # require Logger

  @enforce_keys [:equations]
  defstruct equations: nil

  alias EquationSolver.{TaskBook, Solver, Equation}

  @doc """
    Функция инита сольвера, читает уравнения из csv.файла.
    Файл создан как проверка сервера и вывода списка на фронте.
    Запись в файле не реализована, можно использовать как архив решений уравнений
  """
  def new() do
    tasks = TaskBook.read_tasks()
    Solver.new(tasks)
  end

  def new(tasks) do
    equations =
      tasks
      |> Enum.shuffle()
      |> Enum.map(&Equation.from_task(&1))

    %Solver{ equations: equations }
  end

  def run_solver(solver) do
    new_equations =
      solver.equations
      |> Enum.map(&Equation.from_equation(&1))
    %{solver | equations: new_equations }
  end

  @doc """
    Функция вызова решателя нового уравнения, первый вариант
  """
  def solve(solver, equation) do
    # Logger.error( "-----------------------> input solve.equation: #{inspect equation}" )

    new_equation =
       equation
       |> Enum.map(&Equation.from_equation(&1))
    %{solver | equations: new_equation }
  end

  @doc """
    Функция вызова решателя нового уравнения
  """
  def solve_new_equation(solver, constants, type) do

    # Logger.error( "-----------------------> constants: #{inspect constants}" )
    # Logger.error( "-----------------------> type: #{inspect type}" )

    new_equation = Equation.from_task(%{type: type, constants: constants})

    %{solver | equations: new_equation }
  end

end
