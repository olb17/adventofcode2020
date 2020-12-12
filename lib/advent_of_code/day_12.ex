defmodule AdventOfCode.Day12 do
  def part1(args) do
    %{x: x, y: y} =
      args
      |> parse_args()
      |> Enum.reduce(%{cap: 0, x: 0, y: 0}, &move_boat(&1, &2))

    Kernel.abs(x) + Kernel.abs(y)
  end

  def move_boat({"N", val}, %{y: y} = boat), do: %{boat | y: y + val}
  def move_boat({"S", val}, %{y: y} = boat), do: %{boat | y: y - val}
  def move_boat({"E", val}, %{x: x} = boat), do: %{boat | x: x + val}
  def move_boat({"W", val}, %{x: x} = boat), do: %{boat | x: x - val}

  def move_boat({"L", val}, %{cap: cap} = boat),
    do: %{boat | cap: Kernel.rem(cap + val + 360, 360)}

  def move_boat({"R", val}, %{cap: cap} = boat),
    do: %{boat | cap: Kernel.rem(cap - val + 360, 360)}

  def move_boat({"F", val}, %{cap: cap} = boat) do
    case cap do
      0 -> move_boat({"E", val}, boat)
      90 -> move_boat({"N", val}, boat)
      180 -> move_boat({"W", val}, boat)
      270 -> move_boat({"S", val}, boat)
    end
  end

  def part2(args) do
    %{x: x, y: y} =
      args
      |> parse_args()
      |> Enum.reduce(%{waypoint: {10, 1}, x: 0, y: 0}, &move_boat_waypoint(&1, &2))

    Kernel.abs(x) + Kernel.abs(y)
  end

  def move_boat_waypoint({"S", val}, %{waypoint: {x, y}} = boat),
    do: %{boat | waypoint: {x, y - val}}

  def move_boat_waypoint({"N", val}, %{waypoint: {x, y}} = boat),
    do: %{boat | waypoint: {x, y + val}}

  def move_boat_waypoint({"E", val}, %{waypoint: {x, y}} = boat),
    do: %{boat | waypoint: {x + val, y}}

  def move_boat_waypoint({"W", val}, %{waypoint: {x, y}} = boat),
    do: %{boat | waypoint: {x - val, y}}

  def move_boat_waypoint({"L", val}, %{waypoint: {x, y}} = boat) do
    case val do
      0 -> boat
      90 -> %{boat | waypoint: {-y, x}}
      180 -> %{boat | waypoint: {-x, -y}}
      270 -> %{boat | waypoint: {y, -x}}
    end
  end

  def move_boat_waypoint({"R", val}, %{waypoint: {x, y}} = boat) do
    case val do
      0 -> boat
      90 -> %{boat | waypoint: {y, -x}}
      180 -> %{boat | waypoint: {-x, -y}}
      270 -> %{boat | waypoint: {-y, x}}
    end
  end

  def move_boat_waypoint({"F", val}, %{waypoint: {x, y}, x: boat_x, y: boat_y} = boat) do
    %{boat | x: boat_x + val * x, y: boat_y + val * y}
  end

  def parse_args(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn elt ->
      {String.slice(elt, 0..0), String.slice(elt, 1..-1) |> Integer.parse() |> elem(0)}
    end)
  end
end
