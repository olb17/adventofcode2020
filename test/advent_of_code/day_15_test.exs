defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  @args """
  0,3,6
  """
  @tag :skipno
  test "part1" do
    input = @args
    IO.write("\n")

    result =
      part1(input)
      |> IO.inspect(label: "res")

    assert result
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
