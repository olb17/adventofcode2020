defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  @args """
  939
  3,7,11
  """
  @args_ol """
  939
  7,13,x,x,59,x,31,19
  """

  @tag :skip
  test "part1" do
    input = @args
    result = part1(input)

    assert result == 295
  end

  @tag :skipno
  test "part2" do
    input = @args

    result =
      part2(input)
      |> IO.inspect(label: "result")
    assert result
  end
end
