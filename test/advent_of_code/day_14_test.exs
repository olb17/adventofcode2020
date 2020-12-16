defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.Day14

  @args """
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """

  @arg_part2 """
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""
  @tag :skip
  test "part1" do
    input = @args

    result =
      part1(input)
      |> IO.inspect(label: "res")

    assert result
  end

  @tag :skip
  test "part2" do
    input = @arg_part2
IO.write("\n")

    result =
      part2(input)
      |> IO.inspect(label: "res")

    assert result
  end
end
