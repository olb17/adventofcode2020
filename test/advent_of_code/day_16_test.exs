defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  @args """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"""

@args2 """
departure: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
125,5,9
"""

@tag :skip
  test "part1" do
    input = @args
    IO.inspect("\n")
        result = part1(input)
    |> IO.inspect(label: "res1")
    assert result
  end

  @tag :skip
  test "part2" do
    input = @args2
    IO.inspect("\n")
    result = part2(input)
|> IO.inspect(label: "res2")
    assert result
  end
end
