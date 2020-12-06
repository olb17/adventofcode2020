defmodule AdventOfCode.Day06 do
  def part1(args) do
    args
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.trim()
      |> String.split("\n")
      |> Enum.flat_map(&String.graphemes/1)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.trim()
      |> String.split("\n")
      |> Enum.reduce({%{}, 0}, fn person, {map, count} ->
        map =
          String.graphemes(person)
          |> Enum.reduce(map, fn letter, m ->
            {_, m} =
              Map.get_and_update(m, letter, fn value ->
                case value do
                  nil -> {value, 1}
                  val -> {value, val + 1}
                end
              end)

            m
          end)

        {map, count + 1}
      end)
      |> find_answers()
    end)
    |> Enum.sum()
  end

  defp find_answers({map, count}) do
    Enum.filter(map, fn {_k, v} -> v == count end)
    |> Enum.count()
  end
end
