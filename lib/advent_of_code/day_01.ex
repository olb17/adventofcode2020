defmodule AdventOfCode.Day01 do
  def part1(args) do
    nbs =
      String.split(args, ["\n", "\r", "\r\n"])
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(fn e ->
        case e do
          {ret, _} -> ret
          _ -> nil
        end
      end)
      |> Enum.filter(&(&1 != nil))

    for i <- nbs,
        j <- nbs do
      if i + j == 2020 do
        i * j
      end
    end
    |> Enum.filter(fn e -> e != nil end)
    |> hd()
  end

  def part2(args) do
    nbs =
      String.split(args, ["\n", "\r", "\r\n"])
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(fn e ->
        case e do
          {ret, _} -> ret
          _ -> nil
        end
      end)
      |> Enum.filter(&(&1 != nil))

    for i <- nbs,
        j <- nbs,
        k <- nbs do
      if i + j + k == 2020 do
        i * j * k
      end
    end
    |> Enum.filter(fn e -> e != nil end)
    |> hd()
  end
end
