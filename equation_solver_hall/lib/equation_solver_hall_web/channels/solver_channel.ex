defmodule EquationSolverHallWeb.SolverChannel do
  use EquationSolverHallWeb, :channel

  alias EquationSolverHallWeb.Presence
  alias EquationSolver.SolverServer

  require Logger

  def join("solvers:" <> solver_name, _params, socket) do
    case SolverServer.solver_pid(solver_name) do
      pid when is_pid(pid) ->
        send(self(), {:after_join, solver_name})
        {:ok, socket}

      nil ->
        {:error, %{reason: "Solver does not exist"}}
    end
  end

  def handle_info({:after_join, solver_name}, socket) do

    summary = SolverServer.summary(solver_name)

    # Logger.error( "-----------------------> after_join.summary: #{inspect summary}" )

    push(socket, "solver_summary", summary)

    push(socket, "presence_state", Presence.list(socket))

    {:ok, _} =
      Presence.track(socket, current_user(socket).name, %{
        online_at: "" # online_at: inspect(System.system_time())
      })

    {:noreply, socket}
  end

  def handle_in("solve_equation", %{"equations" => equations}, socket) do
    "solvers:" <> solver_name = socket.topic

    case SolverServer.solver_pid(solver_name) do
      pid when is_pid(pid) ->
        summary = SolverServer.solve(solver_name, equations)

        broadcast!(socket, "solver_summary", summary)

        {:noreply, socket}

      nil ->
        {:reply, {:error, %{reason: "Solver does not exist"}}, socket}
    end
  end

  def handle_in("solve_new_equation", msg, socket) do
    "solvers:" <> solver_name = socket.topic
    case SolverServer.solver_pid(solver_name) do
      pid when is_pid(pid) ->

        summary = SolverServer.solve_new_equation(solver_name, msg["constants"], msg["type"])

        # Logger.error( "-----------------------> solve_new_equation.summary: #{inspect summary}" )

        broadcast!(socket, "solver_summary", summary)

        {:noreply, socket}

      nil ->
        {:reply, {:error, %{reason: "Solver does not exist"}}, socket}
    end
  end

  def handle_in("new_chat_message", %{"body" => body}, socket) do
    broadcast!(socket, "new_chat_message", %{
      name: current_user(socket).name,
      body: body
    })

    {:noreply, socket}
  end

  defp current_user(socket) do
    socket.assigns.current_user
  end
end
