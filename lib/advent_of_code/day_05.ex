defmodule AdventOfCode.Day05 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split(["\n"])
    |> Enum.map(fn str ->
      row = String.slice(str, 0..6) |> String.graphemes() |> decipher_row(6, 0)
      col = String.slice(str, -3..-1) |> String.graphemes() |> decipher_row(2, 0)
      row * 8 + col
    end)
    |> Enum.max()
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split(["\n"])
    |> Enum.map(fn str ->
      row = String.slice(str, 0..6) |> String.graphemes() |> decipher_row(6, 0)
      col = String.slice(str, -3..-1) |> String.graphemes() |> decipher_row(2, 0)
      row * 8 + col
    end)
    |> Enum.sort()
    |> find_missing()
  end

  def find_missing([a | [b | [c | rest]]]) do
    if a + 1 == b && b + 1 == c do
      find_missing([b | [c | rest]])
    else
      b + 1
    end
  end

  def decipher_row([c | charlist], rank, value) do
    case c do
      "L" ->
        decipher_row(charlist, rank - 1, value)

      "F" ->
        decipher_row(charlist, rank - 1, value)

      "R" ->
        decipher_row(charlist, rank - 1, round(:math.pow(2, rank)) + value)

      "B" ->
        decipher_row(charlist, rank - 1, round(:math.pow(2, rank)) + value)
    end
  end

  def decipher_row([], _rank, value) do
    value
  end
end
