defmodule EquationSolverHallWeb.SessionController do
  use EquationSolverHallWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"name" => name}}) do
    user = EquationSolver.User.new(name)

    conn
    |> put_session(:current_user, user)
    |> redirect_back_or_to_new_solver
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: "/")
  end

  defp redirect_back_or_to_new_solver(conn) do
    path = get_session(conn, :return_to) || solver_path(conn, :new)

    conn
    |> put_session(:return_to, nil)
    |> redirect(to: path)
  end
end
