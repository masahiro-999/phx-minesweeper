defmodule MineSweeperWeb.Game do
  use MineSweeperWeb, :live_view

  def render(assigns) do
    ~H"""
      <.live_component module={MineSweeperWeb.Components.MineSweeperGui} xs="10" ys="10" bomb="10" id={1}/>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0)}
  end
end
