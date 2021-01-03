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

  @tag :skip
  test "part2" do
    assert part2("5 * 6 + 2") == 40
    assert part2("2 * 3 + (4 * 5)") == 46
    assert part2("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445
    assert part2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669_060
    assert part2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340
  end
end
