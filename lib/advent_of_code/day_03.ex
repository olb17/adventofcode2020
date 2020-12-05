defmodule AdventOfCode.Day03 do
  def part1(args) do
    map =
      args
      |> String.split(["\n", "\r", "\r\n"])
      |> Enum.filter(fn line -> String.length(line) > 0 end)
      |> load_map

    slide({0, 0}, 3, 1, map, 0)
  end

  def part2(args) do
    map =
      args
      |> String.split(["\n", "\r", "\r\n"])
      |> Enum.filter(fn line -> String.length(line) > 0 end)
      |> load_map

    slide({0, 0}, 1, 1, map, 0) *
      slide({0, 0}, 3, 1, map, 0) *
      slide({0, 0}, 5, 1, map, 0) *
      slide({0, 0}, 7, 1, map, 0) *
      slide({0, 0}, 1, 2, map, 0)
  end

  def slide({posx, posy}, slopex, slopey, map, nb_trees) do
    new_posx = posx + slopex
    new_posy = posy + slopey

    if is_overmap(map, new_posy) do
      nb_trees
    else
      nb_trees =
        if is_tree(map, posx + slopex, posy + slopey) do
          nb_trees + 1
        else
          nb_trees
        end

      slide({new_posx, new_posy}, slopex, slopey, map, nb_trees)
    end
  end

  def load_map(lines) do
    line = Enum.at(lines, 0)
    {lines, String.length(line)}
  end

  def is_tree({lines, width}, posx, posy) do
    line = Enum.at(lines, posy)
    coord = String.at(line, rem(posx, width))
    coord == "#"
  end

  def is_overmap({lines, _width}, posy) do
    Enum.count(lines) <= posy
  end
end
