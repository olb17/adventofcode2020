defmodule AdventOfCode.Day10 do
  def part1(args) do
    outlets =
      args
      |> parse_args()
      |> Enum.sort()
      |> Enum.reverse()

    from_outlet = outlets ++ [0]
    from_device = [hd(outlets) + 3] ++ outlets

    result =
      Enum.zip(from_outlet, from_device)
      |> Enum.map(&(elem(&1, 1) - elem(&1, 0)))
      |> Enum.group_by(& &1)
      |> Enum.map(fn {key, val} -> {key, Enum.count(val)} end)
      |> Map.new()

    result[3] * result[1]
  end

  def part2(args) do
    outlets =
      args
      |> parse_args()
      |> Enum.sort()
      |> Enum.reverse()

    from_outlet = outlets ++ [0]
    from_device = [hd(outlets) + 3] ++ outlets

    {acc, last} =
      Enum.zip(from_outlet, from_device)
      |> Enum.reduce({1, 0}, fn {left, right}, {acc, nb} ->
        gap = right - left

        cond do
          gap == 3 && nb > 0 ->
            {acc * nb_combin(nb), 0}

          gap == 3 && nb == 0 ->
            {acc, nb}

          gap == 1 ->
            {acc, nb + 1}
        end
      end)

    if last != 0 do
      acc * nb_combin(last)
    else
      acc
    end
  end

  def nb_combin(nb) when nb > 2 do
    :math.pow(2, nb - 1) - :math.pow(2, nb - 3) + 1
  end

  def nb_combin(nb) when nb == 2, do: 2

  def nb_combin(nb) when nb == 1, do: 1

  def parse_args(args) do
    args
    |> String.trim()
    |> String.split(["\n"])
    |> Enum.map(fn elt ->
      Integer.parse(elt) |> elem(0)
    end)
  end
end
