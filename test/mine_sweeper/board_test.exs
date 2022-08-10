defmodule MineSweeper.BoardTest do
  use ExUnit.Case
  # use MineSweeperWeb.ConnCase
  alias MineSweeper.Board

  test "create_initial_board" do
    board = Board.create_initial_board(3,4,5)
    assert board.xs == 3
    assert board.ys == 4
    assert tuple_size(board.cells) == 3*4
    assert elem(board.cells, 0) == :nomark
    assert elem(board.cells, 3*4-1) == :nomark
  end

  test "can_reval?" do
    board =%Board{
      cells: {:nomark, :nomark, :marked, 0}
    }
    assert Board.can_reval?(board, 0) == true
    assert Board.can_reval?(board, 1) == true
    assert Board.can_reval?(board, 2) == false
    assert Board.can_reval?(board, 3) == false
  end

  test "bomb?" do
    board =%Board{
      bomb: [2,5]
    }
    assert Board.bomb?(board, 0) == false
    assert Board.bomb?(board, 2) == true
    assert Board.bomb?(board, 5) == true
  end

  test "do_mark" do
    board = Board.create_initial_board(3,4,5)
    |> Board.do_mark(3)
    assert elem(board.cells, 3) == :marked
  end

  test "add" do
    assert Board.add({1,2}, {3,4}) == {4,6}
  end

  test "get_index_of_around" do
    board = Board.create_initial_board(3,3,5)
    xylist = Board.get_index_of_around(board, 4)
    assert Enum.sort(xylist) == [0,1,2,3,5,6,7,8]
  end

  test "get_index_of_around 0" do
    board = Board.create_initial_board(3,3,5)
    xylist = Board.get_index_of_around(board, 0)
    assert Enum.sort(xylist) == [1,3,4]
  end

  test "get_index_of_around 2" do
    board = Board.create_initial_board(3,3,5)
    xylist = Board.get_index_of_around(board, 2)
    assert Enum.sort(xylist) == [1,4,5]
  end

  test "get_index_of_around 6" do
    board = Board.create_initial_board(3,3,5)
    xylist = Board.get_index_of_around(board, 6)
    assert Enum.sort(xylist) == [3,4,7]
  end

  test "get_index_of_around 8" do
    board = Board.create_initial_board(3,3,5)
    xylist = Board.get_index_of_around(board, 8)
    assert Enum.sort(xylist) == [4,5,7]
  end

  test "number_of_bomb" do
    board =%Board{
      xs: 3,
      ys: 3,
      bomb: [0,1]
    }
    assert Board.number_of_bomb(board,4) == 2
  end

  test "clear?1" do
    board =%Board{
      xs: 2,
      ys: 2,
      bomb: [0,1],
      cells: {:nomark, :marked, 2, 2}
    }
    assert Board.clear?(board) == true
  end

  test "cell_reval" do
    board = %Board{
      xs: 10,
      ys: 10,
      cells: Tuple.duplicate(:nomark, 100),
      gameover: false,
      clear: false,
      number_of_bomb: 0,
      bomb: []
    }
    |> Board.cell_reval(50)
    cells = Tuple.to_list(board.cells)
    assert Enum.all?(cells, fn(cell) -> cell==0 end) == true
  end

  test "cell_reval2" do
    board = %Board{
      xs: 10,
      ys: 10,
      cells: Tuple.duplicate(:nomark, 100),
      gameover: false,
      clear: false,
      number_of_bomb: 0,
      bomb: [0,1]
    }
    |> Board.cell_reval(50)
    assert elem(board.cells, 2) == 1
    assert elem(board.cells, 10) == 2
    assert elem(board.cells, 11) == 2
    assert elem(board.cells, 12) == 1
  end

  test "clear_check" do
    board = %Board{
      xs: 10,
      ys: 10,
      cells: Tuple.duplicate(:nomark, 100),
      gameover: false,
      clear: false,
      number_of_bomb: 0,
      bomb: [0,1]
    }
    |> Board.cell_reval(50)
    |> Board.clear_check()
    assert board.clear == true
  end

  test "reval1" do
    board = %Board{
      xs: 10,
      ys: 10,
      cells: Tuple.duplicate(:nomark, 100),
      gameover: false,
      clear: false,
      number_of_bomb: 0,
      bomb: [0,1]
    }
    |> Board.reval(50)
    assert elem(board.cells, 2) == 1
    assert elem(board.cells, 10) == 2
    assert elem(board.cells, 11) == 2
    assert elem(board.cells, 12) == 1
  end

  test "reval2" do
    board = %Board{
      xs: 10,
      ys: 10,
      cells: Tuple.duplicate(:nomark, 100),
      gameover: false,
      clear: false,
      number_of_bomb: 0,
      bomb: [0,1]
    }
    |> Board.reval(0)
    assert board.gameover == true
  end

  test "toggle_mark" do
    board = Board.create_initial_board(3,3,5)
    |> Board.toggle_mark(0)
    assert board.cells == {:marked ,:nomark,:nomark,:nomark,:nomark,:nomark,:nomark,:nomark,:nomark}
  end

  test "toggle_mark2" do
    board = Board.create_initial_board(3,3,5)
    |> Board.toggle_mark(0)
    |> Board.toggle_mark(0)
    assert board.cells == {:nomark,:nomark,:nomark,:nomark,:nomark,:nomark,:nomark,:nomark,:nomark}
  end

  test "toggle_mark3" do
    board = %Board{
      xs: 2,
      ys: 2,
      cells: {1,:nomark,:nomark,:nomark},
      gameover: false,
      clear: false,
      number_of_bomb: 0,
      bomb: [1,2]
    }
    |> Board.toggle_mark(0)
    assert board.cells == {1,:nomark,:nomark,:nomark}
  end

end
