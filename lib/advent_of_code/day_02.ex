defmodule AdventOfCode.Day02 do
  def part1(args) do
    String.split(args, ["\n", "\r", "\r\n"])
    |> Enum.map(fn line ->
      # 1-3 a: abcde
      case Regex.run(~r/^([[:digit:]]+)-([[:digit:]]+) ([[:alpha:]]): ([[:alpha:]]+)$/, line) do
        [_, min_str, max_str, pwd, test] ->
          {min_str, max_str, pwd, test}

        nil ->
          nil
      end
    end)
    |> Enum.filter(&test_instruction_part1(&1))
    |> Enum.count()
  end

  def part2(args) do
    String.split(args, ["\n", "\r", "\r\n"])
    |> Enum.map(fn line ->
      # 1-3 a: abcde
      case Regex.run(~r/^([[:digit:]]+)-([[:digit:]]+) ([[:alpha:]]): ([[:alpha:]]+)$/, line) do
        [_, min_str, max_str, pwd, test] ->
          {min_str, max_str, pwd, test}

        nil ->
          nil
      end
    end)
    |> Enum.filter(&test_instruction_part2(&1))
    |> Enum.count()
  end

  def test_instruction_part2({pos1_str, pos2_str, pwd, test}) do
    {pos1, _} = Integer.parse(pos1_str)
    {pos2, _} = Integer.parse(pos2_str)

    val1 =
      if String.at(test, pos1 - 1) == pwd do
        1
      else
        0
      end

    val2 =
      if String.at(test, pos2 - 1) == pwd do
        1
      else
        0
      end

    val1 + val2 == 1
  end

  def test_instruction_part2(nil) do
    false
  end

  def test_instruction_part1({min_str, max_str, pwd, test}) do
    {min, _} = Integer.parse(min_str)
    {max, _} = Integer.parse(max_str)
    count = test |> String.graphemes() |> Enum.count(fn c -> c == pwd end)

    count >= min && count <= max
  end

  def test_instruction_part1(nil) do
    false
  end
end
