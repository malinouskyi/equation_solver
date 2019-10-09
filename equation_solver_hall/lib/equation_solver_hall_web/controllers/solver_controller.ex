defmodule EquationSolverHallWeb.SolverController do
  use EquationSolverHallWeb, :controller

  plug :require_user

  alias EquationSolver.{SolverServer, SolverSupervisor}

  def new(conn, _) do
    render(conn, "new.html")
  end


  def create(conn, _params) do
    solver_name = EquationSolverHall.HaikuName.generate()
    # size = String.to_integer(size), %{"solver" => %{"size" => size}}
    # inspect(size)
    case SolverSupervisor.start_solver(solver_name) do
      {:ok, _solver_pid} ->
        redirect(conn, to: solver_path(conn, :show, solver_name))

      {:error, _error} ->
        conn
        |> put_flash(:error, "Unable to start solver!")
        |> redirect(to: solver_path(conn, :new))
    end
  end

  def show(conn, %{"id" => solver_name}) do
    case SolverServer.solver_pid(solver_name) do
      pid when is_pid(pid) ->
        conn
        |> assign(:solver_name, solver_name)
        |> assign(:auth_token, generate_auth_token(conn))
        |> render("show.html")

      nil ->
        conn
        |> put_flash(:error, "Solver not found!")
        |> redirect(to: solver_path(conn, :new))
    end
  end

  defp require_user(conn, _opts) do
    if get_session(conn, :current_user) do
      conn
    else
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  defp generate_auth_token(conn) do
    current_user = get_session(conn, :current_user)
    Phoenix.Token.sign(conn, "user auth", current_user)
  end
end
