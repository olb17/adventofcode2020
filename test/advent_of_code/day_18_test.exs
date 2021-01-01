defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  @tag :skip
  test "part1" do
    input = "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"
    IO.write("\n")
    res = part1(input) |> IO.inspect(label: input)
    assert res == 12240
  end

  @tag :skipno
  test "part2" do
    input = "5 * 6 + 2"

    res =
      part2(input)
      |> IO.inspect(label: input)

    assert res == 40
  end
end
