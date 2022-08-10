defmodule MineSweeperWeb.MineSweeperView do
  use Phoenix.LiveView
  use PetalComponents
  alias MineSweeper.Board

  @doc """
  Game Board components
  """
  def render(assigns) do
    ~H"""
    <div class="centering_parent">
    <div class="grid grid-cols-1 gap-4 place-content-center">
    <div class="centering_item" id='map' style={style_string(@board)}>
      <%= for {index, class_string, value} <- create_elements(@board) do %>
      <div phx-hook="Drag" class={class_string} phx-click="clicked" id={"cell"<>Integer.to_string(index)} phx-value-pos={index}>
      <%= value %>
      </div>
      <% end %>
    </div>
    <div draggable="true" id="dragtest" class="draggable centering_item cell flag" id='map' style="
    display: grid;
    width: 40px;
    height: 40px;">
    </div>
    <%= if @board.clear or @board.gameover do %>
    <.button class="centering_item" phx-click="new_game">New Game</.button>
    <% end %>
    </div>

    </div>
    """
  end

  def mount(_params, session, socket) do
    board = Board.create_initial_board(10,10,10)
    {:ok, assign(socket, board: board)}
  end


  def handle_event("clicked", %{"pos" => string_pos}, socket) do
    pos = String.to_integer(string_pos)
    {:noreply, update(socket, :board, &Board.reval(&1, pos))}
  end

  def handle_event("dropped", %{"pos" => string_pos}, socket) do
    pos = String.to_integer(string_pos)
    {:noreply, update(socket, :board, &Board.toggle_mark(&1, pos))}
  end

  def handle_event("new_game", _ , socket) do
    board = socket.assigns.board
    board = Board.create_initial_board(
      board.xs, board.ys, board.number_of_bomb)
    {:noreply, update(socket, :board, fn _ -> board end)}
  end

  def style_string(board) do
    px = 40
    "display: grid;
      grid-template-columns: repeat(#{board.xs},#{px}px);
      grid-template-rows: repeat(#{board.ys},#{px}px);
      width: #{board.xs*px}px;
      height: #{board.ys*px}px;"
  end

  @spec create_elements(atom | %{:xs => integer, :ys => integer, optional(any) => any}) :: list
  def create_elements(board) do
    for index <- 0..(board.xs*board.ys-1) do
      {index, get_class_string(board, index), get_value_string(board, index)}
    end
  end

  def get_class_string(board, index) do
    cell = elem(board.cells, index)
    (["cell"]
    ++
    (if board.clear, do: ["clear"], else: [])
    ++
    (if board.gameover, do: ["gameover"], else: [])
    ++
    (if (board.gameover or board.clear) and index in board.bomb, do: ["bomb"], else: [])
    ++
    if cell == :marked, do: ["flag"], else: (if cell != :nomark, do: ["open"], else: []))
    |> Enum.join(" ")
  end

  def get_value_string(board, index) do
    cell = elem(board.cells, index)
    cond do
      is_atom(cell) -> ""
      true -> Integer.to_string(cell)
    end
  end

end
