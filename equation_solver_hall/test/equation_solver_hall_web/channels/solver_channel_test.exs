defmodule EquationSolverHallWeb.SolverChannelTest do
  use EquationSolverHallWeb.ChannelCase

  alias EquationSolverHallWeb.SolverChannel
  alias EquationSolver.{SolverServer, SolverSupervisor, Equation, User}

  setup do
    solver_name = "test-solver-123"
    topic = "solvers:#{solver_name}"

    SolverSupervisor.start_solver(solver_name)

    user = User.new("Dima")

    token = Phoenix.Token.sign(socket(), "user auth", user)

    {:ok, socket} = connect(EquationSolverHallWeb.UserSocket, %{"token" => token})

    new_equations = [
      sq("linear", "2x+30=12")
    ]
    new_msg = %{type: "linear", constants: "2x+30=12"}

    [
      solver_name: solver_name,
      topic: topic,
      socket: socket,
      user: user,
      new_equations: new_equations,
      new_msg: new_msg
    ]


  end

  describe "инит канала" do
    test "вытянуть начальные данные", context do
      {:ok, _reply, _socket} =
        subscribe_and_join(context.socket, SolverChannel, context.topic, %{})

      assert context.socket.assigns.current_user == context.user

      assert_push("presence_state", %{})

      summary = SolverServer.summary(context.solver_name)

      assert_push("solver_summary", ^summary)
    end

    test "возвращает ошибку, если решатель не существует", context do
      assert {:error, %{reason: "Solver does not exist"}} =
        subscribe_and_join(context.socket, SolverChannel, "solvers:9999", %{})
    end
  end

  describe "проверка ф-ции решателя нового уравнения" do
    test "broadcasts the new solver summary", context do
      {:ok, _reply, socket} =
        subscribe_and_join(context.socket, SolverChannel, context.topic, %{})

      # summary = SolverServer.summary(context.solver_name)
      push(socket, "solve_new_equation", context.new_msg )

      assert_broadcast("solver_summary", %{})
    end

    # test "вернуть nil, если сервер не существует", context do
    #   {:ok, _reply, socket} =
    #     subscribe_and_join(context.socket, SolverChannel, context.topic, %{})

    #   pid = SolverServer.solver_pid(context.solver_name)

    #   Process.exit(pid, :kill)
    #   # :timer.sleep(2000)
    #   ref = push(socket, "solve_equation", %{equations: context.new_equations})

    #   # assert_reply ref, :ok, %{"hello" => "there"}
    #   # assert_reply ref, :error, %{reason: "Solver does not exist"}
    # end
  end

  defp sq(type, constants) do
    Equation.new(type, constants)
  end

end
