defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  @args """
    16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4
  """
  @tag :skip
  test "part1" do
    input = @args
    result = part1(input)

    assert result == 35
  end

  @tag :skip
  test "part2" do
    assert nb_combin(1) == 1
    assert nb_combin(2) == 2
    assert nb_combin(3) == 4
    assert nb_combin(4) == 7
    assert nb_combin(5) == :math.pow(2, 4) - 3

    input = @args
    result = part2(input)

    assert result
  end
end
