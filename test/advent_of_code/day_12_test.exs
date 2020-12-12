defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @args """
  F10
  N3
  F7
  R90
  F11
  """

  @tag :skip
  test "part1" do
    input = @args

    result =
      part1(input)
      |> IO.inspect(label: "result")

    assert result
  end

  @tag :skip
  test "part2" do
    input = @args

    result =
      part2(input)
      |> IO.inspect(label: "result")

    assert result
  end
end
