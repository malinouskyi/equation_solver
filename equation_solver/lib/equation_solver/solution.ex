defmodule EquationSolver.Solution do
  @moduledoc """
  Решения уравнений. Структура ответов.
  """
  @enforce_keys [:type, :constants]
  defstruct [:type, :constants, :status, :answer]

  alias __MODULE__

  require Logger

  @doc """
  Конструктор структуры ответов в зависимости от типа уравнения.

    ## Параметры
    - type: Строка, в которой находится тип уравнения.
    - constants: Строка, в которой находится условие уравнения

    ## Примеры
      solution = Solution.new("linear", "x+5-3+x=6+x-2")

  """
  def new(type, constants) do
    {status, answer} = case type do
      "quadratic" ->
        solve_quadratic(constants)
      "linear"  ->
        solve_linear(constants)
      _ ->
        solve_other(constants)
    end

    %Solution{type: type, constants: constants, status: status, answer: answer }
  end

  # @doc """
  # Формирует список частей строки через разделитель.

  #   ## Параметры
  #   - string: Строка условия. например  a=2
  #   - split_char: Символ разделителя, например "="

  # """
  defp split(string, split_char) do
    if String.contains?(string, split_char) do
      String.splitter(string, split_char)|> Enum.map(fn x -> String.replace(x, split_char, "")end)
    else
      ""
    end
  end

  # @doc """
  # Получает ответ квадратного уранения.

  #   ## Параметры
  #   - constants: Строка условия. например  a = 1, b = 3, c = 5

  # """
  defp solve_quadratic(constants) do
    # a=2, b=1, c=3
    trim_str = for <<c <- constants>>, c != ?\s, into: "", do: <<c>>
    equation =
      trim_str
      |> String.replace(~r/\r|\n/, "")
      |> String.split(",")
      |> Enum.map(fn k ->
              split(k, "=")
              |> Enum.chunk_every(2)
              |> Enum.into(%{}, fn [a, b] -> {a, b} end)
      end)

    try do
      a = String.to_integer( Enum.find_value(equation, false, fn(x)-> x["a"]  end) )
      b = String.to_integer( Enum.find_value(equation, false, fn(x)-> x["b"]  end) )
      c = String.to_integer( Enum.find_value(equation, false, fn(x)-> x["c"]  end) )

      solvequadratic a, b, c
    rescue
      e in ArgumentError -> {"0", "Error: #{e.message}"}
    end

  end

  # @doc """
  # Получает ответ линейного уранения.

  #   ## Параметры
  #   - constants: Строка условия. например  x+5-3+x=6+x-2

  # """
  defp solve_linear(constants) when is_bitstring(constants)  do
    try do
      equation =
        for <<c <- constants>>, c != ?\s, into: "", do: <<c>>
        |> String.replace(~r/\r|\n/, "")

      n = String.length(equation)
      {status, solution} =
        equation
        |> String.codepoints()
        |> solvelinear(equation, n, 0, 0, 1, 0, 0)

      {status, solution}
    rescue
      e in ArgumentError -> {"0", "Error: #{e.message}"}
    end
  end

  # @doc """
  # Заглушка для уранений других типов.

  #   ## Параметры
  #   - constants: Строка условия.

  # """
  defp solve_other(constants) do

    {"0", "Нет Решателя для #{inspect constants}"}

  end

  # @doc """
  # Решатель для линейного уравнения.

  #   ## Параметры
  #   - constants: Строка условия.

  # """
  defp solvelinear([head | tail], list, n, count, i, sign, coeff, total ) do

    {new_i, new_sign, new_coeff, new_total} = cond do
      (head == "+") || (head == "-") ->
        new_total = if (count > i) do
          str = String.slice(list, i, (count - i))
          total + sign * String.to_integer(str)
        else
          total
        end
        new_i = count
        {new_i, sign, coeff, new_total}
      (head == "x") ->
        str = String.slice(list, (count-1), 1)
        new_coeff = cond do
          ((count == i) || str == "+" ) ->
            coeff + sign
          (str == "-") ->
            coeff - sign
          true ->
            substr = String.slice(list, i, (count - i))
            coeff + sign * String.to_integer(substr)
        end
        new_i = count + 1
        {new_i, sign, new_coeff, total}
      (head == "=") ->
        new_total = if (count > i) do
          str = String.slice(list, i, (count - i))
          total + sign * String.to_integer(str)
        else
          total
        end
        new_sign = -1
        new_i = count + 1
        {new_i, new_sign, coeff, new_total}
      true ->
        {i, sign, coeff, total}
    end

    new_count = count + 1

    solvelinear(tail, list, n, new_count, new_i, new_sign, new_coeff, new_total)

  end

  # @doc """
  # Решатель для линейного уравнения. Условие окончания расчета

  #   ## Параметры
  #   - constants: Строка условия.

  # """
  defp solvelinear([], list, n, _count, i, sign, coeff, total) do

    # Logger.debug("total:  #{inspect total}")

    new_total = if (i < n) do
      str = String.slice(list, i,(String.length(list) - i))
      total + sign * String.to_integer(str)
    else
      total
    end


    {status, ans} = cond do
      (coeff == 0 && new_total == 0) ->
        {"0", "Infinite solutions"}
      (coeff == 0 && new_total) ->
        {"0", "No solution"}
      true ->
        ans = -new_total / coeff;
        # "x=" <> Float.to_string(ans, decimals: 2)

        {"1", ans}
    end

    {status, ans}
  end

  # @doc """
  # Решатель для квадратного уравнения.

  #   ## Параметры
  #   - a,
  #   - b,
  #   - c - Число для значения коэффициента.

  # """
  defp solvequadratic(a, b, c) do

    d = b * b - 4 * a * c
    a2 = a * 2
    {status, ans} = cond do
      d > 0 ->
        sd = :math.sqrt(d)
        {"1", " #{(- b + sd) / a2} and #{(- b - sd) / a2}"}
      d == 0 ->
        {"1", " #{- b / a2}"}
      true ->
        sd = :math.sqrt(-d)
        {"1", " #{- b / a2} +/- #{sd / a2}*i"}
    end

    {status, ans}
  end


end
