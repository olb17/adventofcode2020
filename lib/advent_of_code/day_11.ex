defmodule AdventOfCode.Day11 do
  def part1(args) do
    ferry = parse_args(args)

    nb_floor = ferry |> hd() |> Enum.count()
    floor = 0..(nb_floor - 1) |> Enum.map(fn _ -> "." end)

    play_ferry_part1(ferry, floor, true)
    |> Enum.reduce(0, fn row, acc ->
      acc + Enum.count(row, &(&1 == "#"))
    end)
  end

  def part2(args) do
    args
    |> parse_ferry()
    |> play_ferry_part2(true)
    |> Map.get(:map)
    |> Enum.reduce(0, fn {_key, value}, acc ->
      if value == "#", do: acc + 1, else: acc
    end)
  end

  def print_ferry(ferry) do
    IO.write("\n")

    for i <- 0..ferry.row_max do
      for j <- 0..ferry.col_max do
        IO.write(ferry.map[{i, j}])
      end

      IO.write("\n")
    end

    ferry
  end

  def play_ferry_part2(ferry, changed) when changed == true do
    {new_ferry, new_changed} =
      Enum.reduce(ferry.map, {%{}, false}, fn {{row, col}, value}, {acc, map_changed} ->
        {new_value, new_changed} = process_seat(value, row, col, ferry)

        {Map.put(acc, {row, col}, new_value), new_changed || map_changed}
      end)

    play_ferry_part2(%{ferry | map: new_ferry}, new_changed)
  end

  def play_ferry_part2(ferry, changed) when changed == false, do: ferry

  def process_seat(value, row, column, ferry) do
    occupied_nb =
      [
        view_occupied(row, column, ferry, {-1, 0}),
        view_occupied(row, column, ferry, {-1, -1}),
        view_occupied(row, column, ferry, {0, -1}),
        view_occupied(row, column, ferry, {1, -1}),
        view_occupied(row, column, ferry, {1, 0}),
        view_occupied(row, column, ferry, {1, 1}),
        view_occupied(row, column, ferry, {0, 1}),
        view_occupied(row, column, ferry, {-1, 1})
      ]
      # |> IO.inspect(label: "adjacent")
      |> Enum.count(& &1)

    # |>  IO.inspect(label: "occupied")

    cond do
      value == "L" and occupied_nb == 0 ->
        {"#", true}

      value == "#" and occupied_nb >= 5 ->
        {"L", true}

      true ->
        {value, false}
    end
  end

  def view_occupied(row, col, ferry, {inc_row, inc_col} = inc)
      when row + inc_row >= 0 and row + inc_row <= ferry.row_max and
             col + inc_col >= 0 and col + inc_col <= ferry.col_max do
    case ferry.map[{row + inc_row, col + inc_col}] do
      "L" ->
        false

      "#" ->
        true

      _ ->
        view_occupied(row + inc_row, col + inc_col, ferry, inc)
    end
  end

  def view_occupied(_row, _col, _ferry, _inc) do
    false
  end

  def play_ferry_part1(ferry, floor, changed) when changed == true do
    row_before = [floor] ++ ferry
    row = ferry
    row_after = tl(ferry) ++ [floor]

    {reversed_row, changed} =
      Enum.zip([row_before, row, row_after])
      |> Enum.map(&add_border_walls_part1/1)
      |> Enum.map(&play_row_part1(&1, [], false))
      |> Enum.reduce({[], false}, fn {row, changed}, {acc, is_changed} ->
        {[row | acc], is_changed || changed}
      end)

    play_ferry_part1(Enum.reverse(reversed_row), floor, changed)
  end

  def play_ferry_part1(ferry, _floor, changed) when changed == false, do: ferry

  def add_border_walls_part1({r1, r2, r3}) do
    {
      ["." | r1 ++ ["."]],
      ["." | r2 ++ ["."]],
      ["." | r3 ++ ["."]]
    }
  end

  def play_row_part1(
        {[rb1 | [rb2 | [rb3 | row_before]]], [r1 | [r2 | [r3 | row]]],
         [ra1 | [ra2 | [ra3 | row_after]]]},
        acc,
        changed
      ) do
    r2_adjacent_occupied_seats =
      [rb1, rb2, rb3, r1, r3, ra1, ra2, ra3]
      |> Enum.count(&(&1 == "#"))

    {new_r2, new_changed} =
      cond do
        r2_adjacent_occupied_seats == 0 && r2 == "L" ->
          {"#", true}

        r2_adjacent_occupied_seats > 3 && r2 == "#" ->
          {"L", true}

        true ->
          {r2, false}
      end

    play_row_part1(
      {[rb2 | [rb3 | row_before]], [r2 | [r3 | row]], [ra2 | [ra3 | row_after]]},
      [new_r2 | acc],
      changed || new_changed
    )
  end

  def play_row_part1({[_rb1, _rb2], [_r1, _r2], [_ra1, _ra2]}, acc, changed) do
    {Enum.reverse(acc), changed}
  end

  def parse_ferry(args) do
    ferry_map =
      parse_args(args)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, r_index}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {seat, c_index}, acc_row ->
          Map.put(acc_row, {r_index, c_index}, seat)
        end)
      end)

    {row_max, col_max} =
      Enum.reduce(ferry_map, {0, 0}, fn {{row, col}, _}, {row_max, col_max} ->
        {Enum.max([row_max, row]), Enum.max([col_max, col])}
      end)

    %{map: ferry_map, row_max: row_max, col_max: col_max}
  end

  def parse_args(args) do
    args
    |> String.trim()
    |> String.split(["\n"])
    |> Enum.map(fn elt ->
      elt |> String.graphemes()
    end)
  end
end
