defmodule AdventOfCode.Day01 do
  def part1(args) do
    nbs =
      String.split(args, ["\n", "\r", "\r\n"])
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(fn e ->
        elem(e, 0)
      end)

    for i <- nbs,
        j <- nbs do
      if i + j == 2020 do
        IO.inspect(i, label: "i")
        IO.inspect(j, label: "j")
        i * j
      end
    end
    |> Enum.filter(fn e -> e != nil end)
  end

  def part2(args) do
    nbs =
      String.split(args, ["\n", "\r", "\r\n"])
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(fn e ->
        elem(e, 0)
      end)

    for i <- nbs,
        j <- nbs,
        k <- nbs do
      if i + j + k == 2020 do
        IO.inspect(i, label: "i")
        IO.inspect(j, label: "j")
        IO.inspect(j, label: "k")
        i * j * k
      end
    end
    |> Enum.filter(fn e -> e != nil end)
  end
end
