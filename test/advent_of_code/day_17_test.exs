defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  @args """
.#.
..#
###
"""

@args2 """
.#.
..#
###
"""

@tag :skip
  test "part1" do
    input = @args
    IO.write("\n")
    result = part1(input)
             |> IO.inspect(label: "res1")
    assert result
  end

  @tag :skip
  test "part2" do
    input = @args2
    IO.write("\n")
    result = part2(input)
|> IO.inspect(label: "res2")
    assert result
  end
end
