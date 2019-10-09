defmodule EquationSolver.SolverServer do
  @moduledoc """
  Сервер решателя, который содержит вызовы модуля Solver
  """
  alias EquationSolver.{TaskCache, Solver}

  use GenServer

  # require Logger

  @timeout :timer.hours(2)

  ### Клиентский API

  def start_link(solver_name) do
    GenServer.start_link(__MODULE__, {solver_name}, name: via_tuple(solver_name))
  end

  def via_tuple(solver_name) do
    {:via, Registry, {EquationSolver.SolverRegistry, solver_name}}
  end

  @spec solver_pid(any) :: nil | pid | {atom, atom}
  def solver_pid(solver_name) do
    solver_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  def summary(solver_name) do
    GenServer.call(via_tuple(solver_name), :summary)
  end

  def solve(solver_name, equations) do
    # Logger.error( "-----------------------> equations: #{inspect equations}" )
    GenServer.call(via_tuple(solver_name), {:solve, equations})
  end

  @doc """
  Функция вызова решателя нового уравнения
  """
  def solve_new_equation(solver_name, constants, type) do
    GenServer.call(via_tuple(solver_name), {:solve_new_equation, constants, type})
  end

   ### GenServer API

  @doc """
  Функция обратного вызова для GenServer.init/1
  """
  def init({solver_name}) do

    tasks = TaskCache.get_tasks()

    solver =
      case :ets.lookup(:solvers_table, solver_name) do
        [] ->
          solver = Solver.new(tasks)
          :ets.insert(:solvers_table, {solver_name, solver})
          solver

        [{^solver_name, solver}] ->
          solver
    end

    # Logger.info("Spawned solver server process named '#{solver_name}'.")

    {:ok, solver, @timeout}
  end

  def handle_call(:summary, _from, solver) do
    {:reply, summarize(solver), solver, @timeout}
  end

  def handle_call({:solver, equations}, _from, solver) do

    new_solver =  Solver.solve(solver, equations)

    :ets.insert(:solvers_table, {my_solver_name(), new_solver})

    {:reply, summarize(new_solver), new_solver, @timeout}
  end


@doc """
  Функция обратного вызова для GenServer.solve_new_equation/4
"""
  def handle_call({:solve_new_equation, constants, type}, _from, solver) do

    new_solver =  Solver.solve_new_equation(solver, constants, type)

    :ets.insert(:solvers_table, {my_solver_name(), new_solver})

    {:reply, summarize(new_solver), new_solver, @timeout}
  end


  def summarize(solver) do
    %{
      equations: solver.equations
    }
  end

  def handle_info(:timeout, solver) do
    {:stop, {:shutdown, :timeout}, solver}
  end

  def terminate({:shutdown, :timeout}, _solver) do
    :ets.delete(:solvers_table, my_solver_name())
    :ok
  end

  def terminate(_reason, _solver) do
    :ok
  end

  defp my_solver_name do
    Registry.keys(EquationSolver.SolverRegistry, self()) |> List.first
  end
end
