defmodule MineSweeper.Board do
  defstruct [
    :xs,
    :ys,
    :cells,
    gameover: false,
    clear: false,
    number_of_bomb: 0,
    bomb: []
  ]

  def create_initial_board(xs \\ 10, ys \\10, number_of_bomb \\ 3) do
    %__MODULE__{
      xs: xs,
      ys: ys,
      cells: Tuple.duplicate(:nomark, xs*ys),
      gameover: false,
      clear: false,
      number_of_bomb: number_of_bomb,
      bomb: create_bomb_index(xs*ys, number_of_bomb)
    }
  end

  def create_bomb_index(size, number_of_bomb) do
    Enum.take_random(0..size-1, number_of_bomb)
  end

  def reval(board = %__MODULE__{}, index) do
    cond do
      not can_reval?(board, index) -> board
      bomb?(board, index) -> make_game_over(board)
      true -> cell_reval(board, index) |> clear_check()
    end
  end

  def clear_check(board = %__MODULE__{}) do
    cond do
      clear?(board) -> make_clear(board)
      true -> board
    end
  end

  def toggle_mark(board = %__MODULE__{}, index) do
    Map.put(board, :cells,
      put_elem(
        board.cells,
        index,
        case current_value = elem(board.cells, index) do
          :nomark -> :marked
          :marked -> :nomark
          _ -> current_value
        end
        )
    )
  end

  def can_reval?(board = %__MODULE__{}, index) do
    elem(board.cells, index) == :nomark
  end

  def bomb?(board = %__MODULE__{}, index) do
    index in board.bomb
  end

  def cell_reval(board = %__MODULE__{}, index) do
    if can_reval?(board, index) do
      board = Map.put(board, :cells, put_elem(board.cells, index, n = number_of_bomb(board, index)))
      if n == 0 do
        get_index_of_around(board, index)
        |> Enum.reduce(board, fn (index, board) -> cell_reval(board, index) end)
      else
        board
      end
    else
      board
    end
  end

  def make_game_over(board = %__MODULE__{}) do
    Map.put(board, :gameover, true)
  end

  def make_clear(board = %__MODULE__{}) do
    Map.put(board, :clear, true)
  end

  def do_mark(board = %__MODULE__{}, index) do
    %__MODULE__{board | cells: put_elem(board.cells, index, :marked)}
  end

  def marked?(board = %__MODULE__{}, index) do
    elem(board.cells, index) == :marked
  end

  def get_index_of_around(board = %__MODULE__{}, index) do
    xy = index_to_xy(index, board.xs)
    (for x <- -1..1, y <- -1..1 , not( x==0 and y==0) , do: {x,y})
    |> Enum.map(fn xy1 -> add(xy1, xy) end)
    |> Enum.filter( &(within_area?(&1, board.xs, board.ys)))
    |> Enum.map(fn xy1 -> xy_to_index(xy1, board.xs) end)
  end

  def add({x1,y1},{x2,y2}) do
    {x1+x2, y1+y2}
  end

  def within_area?({x,y}, xs, ys) do
    (x >= 0 and x < xs and y >= 0  and y < ys)
  end

  def index_to_xy(index,xs) do
    { rem(index, xs), div(index,xs) }
  end

  def xy_to_index({x,y}, xs) do
    x + y*xs
  end

  def number_of_bomb(board = %__MODULE__{}, index) do
    get_index_of_around(board, index)
    |> Enum.count(fn index -> index in board.bomb end)
  end

  def clear?(board) do
    Enum.with_index(
      Tuple.to_list(board.cells),
      fn (cell, index) ->
          (cell not in [:nomark, :marked] or index in board.bomb)
      end
    )
    |> Enum.all?()
  end

end
