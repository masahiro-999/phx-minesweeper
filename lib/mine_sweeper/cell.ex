defmodule MineSweeper.Board.Cell do
  defstruct [
    :value,
    :open,
    :bomb,
    :flag
  ]
end
