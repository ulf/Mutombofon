defmodule Mutombofon.RoomChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic

  Possible Return Values

  `{:ok, socket}` to authorize subscription for channel for requested topic

  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("room:lobby", _message, socket) do
#    socket = assign(socket, :game, game_token)
    {:ok, socket}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("start", msg, socket) do
    Logger.debug "Start requested"
    {:ok, ack} = Exq.enqueue_in(Exq, "default", 5, "GameStarter", [socket.assigns[:game]])
    broadcast! socket, "game:starting", %{}
    # No reply necessary
    {:noreply, socket}
  end

  def handle_in("new:files", msg, socket) do
    broadcast! socket, "new:files", %{files: msg["files"]}
    {:reply, socket}
  end

  def handle_out("new:files", payload, socket) do
    push socket, "new:files", payload
    {:noreply, socket}
  end
end
