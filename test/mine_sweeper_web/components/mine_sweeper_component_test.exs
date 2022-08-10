defmodule MineSweeperWeb.Components.MineSweeperGuiTest do
  use MineSweeperWeb.ConnCase
  alias MineSweeperWeb.Components.MineSweeperGui
  alias MineSweeper.Board

  # doctest MineSweeperWeb.Components.MineSweeper

  test "create_elements" do
    board = Board.create_initial_board(6,6,5)
    elements = MineSweeperGui.create_elements(board)
    {i,c,v} = Enum.at(elements,1)
    assert i == 1
    assert c == "cell"
    assert v == ""
  end
end
