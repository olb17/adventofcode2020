defmodule AdventOfCode.Day09 do
  @stack_size 25

  def part1(args) do
    stack =
      args
      |> parse_args()
      |> Enum.take(@stack_size)
      |> Enum.reverse()

    args
    |> parse_args()
    |> Enum.drop(@stack_size)
    |> Enum.reduce_while(stack, fn elt, stack ->
      if is_valid(elt, stack) do
        new_stack = [elt | Enum.slice(stack, 0..-2)]
        {:cont, new_stack}
      else
        {:halt, elt}
      end
    end)
  end

  def part2(args) do
    res = part1(args)

    [first | stack] =
      args
      |> parse_args()

    {min, max} = find_right_sum([first | stack], stack, res, first, {first, first})
    min + max
  end

  def find_right_sum([bottom | bottom_rest], [top | top_rest], target, acc, min_max) do
    cond do
      acc + top == target ->
        min_max(top, min_max)

      acc + top < target ->
        find_right_sum([bottom | bottom_rest], top_rest, target, acc + top, min_max(top, min_max))

      true ->
        [new_bottom | new_bottom_rest] = bottom_rest
        find_right_sum(bottom_rest, new_bottom_rest, target, new_bottom, {new_bottom, new_bottom})
    end
  end

  def min_max(nb, {min, max}) do
    cond do
      nb < min -> {nb, max}
      nb > max -> {min, nb}
      true -> {min, max}
    end
  end

  def is_valid(elt, [head | tail]) do
    if(Enum.any?(tail, &(&1 + head == elt))) do
      true
    else
      is_valid(elt, tail)
    end
  end

  def is_valid(_elt, _) do
    false
  end

  def parse_args(args) do
    args
    |> String.trim()
    |> String.split(["\n"])
    |> Enum.map(fn elt ->
      Integer.parse(elt) |> elem(0)
    end)
  end
end
