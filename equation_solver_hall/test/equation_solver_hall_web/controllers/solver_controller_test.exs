defmodule EquationSolverHallWeb.SolverControllerTest do
  use EquationSolverHallWeb.ConnCase

  describe "new" do
    test "redirects to new session if not authenticated", %{conn: conn} do
      conn = get(conn, solver_path(conn, :new))

      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "renders new solver form if authenticated", %{conn: conn} do
      conn = put_user_in_session(conn, "Dima")

      conn = get(conn, solver_path(conn, :new))

      assert html_response(conn, 200) =~ "Старт Решателя"
    end
  end

  describe "create" do
    test "redirects to new session if not authenticated", %{conn: conn} do
      conn = post(conn, solver_path(conn, :create))

      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "redirects to show solver if authenticated", %{conn: conn} do
      conn = put_user_in_session(conn, "Dima")

      conn = post(conn, solver_path(conn, :create), solver: %{"size" => "3"})

      assert %{id: solver_name} = redirected_params(conn)
      assert redirected_to(conn) == solver_path(conn, :show, solver_name)

      conn = get(conn, solver_path(conn, :show, solver_name))
      assert html_response(conn, 200) =~ "solver-container"
    end
  end

  describe "show" do
    test "redirects to new session if not authenticated", %{conn: conn} do
      conn = get(conn, solver_path(conn, :show, "123"))

      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "redirects to new solver if solver does not exist", %{conn: conn} do
      conn = put_user_in_session(conn, "Dima")

      conn = get(conn, solver_path(conn, :show, "nonexistent-solver"))

      assert redirected_to(conn) == solver_path(conn, :new)
    end

    test "shows solver if it exists", %{conn: conn} do
      conn = put_user_in_session(conn, "Dima")

      solver_name = start_solver()

      conn = get(conn, solver_path(conn, :show, solver_name))

      assert html_response(conn, 200) =~ solver_name
    end
  end

  defp start_solver do
    solver_name = EquationSolverHall.HaikuName.generate()

    {:ok, _pid} = EquationSolver.SolverSupervisor.start_solver(solver_name)

    solver_name
  end
end
