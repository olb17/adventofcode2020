defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  @args """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  @args_2 """
  #.LL.LL.L#
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  #.LLLLL.L#
  #.L#.##.L#
  """

  @tag :skip
  test "part1" do
    result = part1(@args)

    assert result
  end

  @tag :skip
  test "part2" do
    ferry = parse_ferry(@args_2)
    assert view_occupied(1, 0, ferry, {1, 0}) == false

    result = part2(@args)
    assert result == 26
  end
end
