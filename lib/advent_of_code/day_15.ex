defmodule AdventOfCode.Day15 do
  def part1(args) do
    {state, next} = parse_args(args)

    execute(state, next, 2020 - state.turn - 1)
  end

  def part2(args) do
    {state, next} = parse_args(args)

    execute(state, next, 30_000_000 - state.turn - 1)
  end

  def execute(%{figures: _figures, turn: _turn} = _state, next, remaining_turn)
      when remaining_turn == 0 do
    next
  end

  def execute(%{figures: figures, turn: turn} = state, next, remaining_turn) do
    new_state = %{state | figures: Map.put(figures, next, turn + 1), turn: turn + 1}

    new_next =
      case Map.get(figures, next) do
        nil -> 0
        pos -> turn - pos + 1
      end

    execute(new_state, new_next, remaining_turn - 1)
  end

  def parse_args(args) do
    figures =
      args
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    nb_figures = Enum.count(figures)

    stack =
      figures
      |> Enum.take(nb_figures - 1)
      |> Enum.with_index(1)
      |> Map.new()

    {%{figures: stack, turn: nb_figures - 1}, hd(Enum.drop(figures, nb_figures - 1))}
  end
end
