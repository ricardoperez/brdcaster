defmodule Brdcaster.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("rooms:lobby", message, socket) do
    #Process.flag(:trap_exit, true)
    #:timer.send_interval(5000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end
  #def handle_info(:ping, socket) do
  #  push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
  #  {:noreply, socket}
  #end


  #def terminate(reason, _socket) do
   #  Logger.debug"> leave #{inspect reason}"
  #  :ok
  #end

  def handle_in("new:msg", %{"body" => body}, socket) do
      IO.inspect("handle_in:" <> body)
      broadcast! socket, "new:msg", %{body: body}
      {:noreply, socket}
  end

  def handle_in("phx_reply", msg, socket) do
      IO.inspect("handle_in:reply" )
      broadcast! socket, "phx_reply", "reply"
      {:reply, socket}
  end

  #def handle_in("new:msg", msg, socket) do
  #  IO.inspect("handle_im: 123")
  #  broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
  #  {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  #end
end
