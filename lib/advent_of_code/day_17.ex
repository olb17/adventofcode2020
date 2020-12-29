defmodule AdventOfCode.Day17 do
  def part1(args) do
    init_cube = parse_args(args)

    1..6
    |> Enum.reduce(init_cube, fn _, cube -> run_cycle(cube, 3) end)
    |> Enum.filter(fn {_, val} -> val == :active end)
    |> Enum.count()
  end

  def part2(args) do
    init_cube = parse_args(args)

    1..6
    |> Enum.reduce(init_cube, fn _, cube -> run_cycle(cube, 4) end)
    |> Enum.filter(fn {_, val} -> val == :active end)
    |> Enum.count()
  end

  def run_cycle(cube, nb_dim) do
    {range_x, range_y, range_z, range_w} = find_cube_domain(cube, nb_dim)

    for x <- range_x, y <- range_y, z <- range_z, w <- range_w do
      {x, y, z, w}
    end
    |> Enum.reduce(Map.new(), fn coord, new_cube ->
      Map.put(new_cube, coord, new_state(cube, coord, nb_dim))
    end)
  end

  def new_state(cube, coord, nb_dim) do
    neighbors =
      find_neighbors(coord, nb_dim)
      |> sum_up_neighbors(cube)

    case Map.get(cube, coord, :inactive) do
      :inactive ->
        cond do
          neighbors.active == 3 -> :active
          true -> :inactive
        end

      :active ->
        cond do
          neighbors.active == 2 or neighbors.active == 3 -> :active
          true -> :inactive
        end
    end
  end

  def find_neighbors({x, y, z, _}, 3) do
    for n_x <- (x - 1)..(x + 1),
        n_y <- (y - 1)..(y + 1),
        n_z <- (z - 1)..(z + 1),
        {n_x, n_y, n_z} != {x, y, z} do
      {n_x, n_y, n_z, 0}
    end
  end

  def find_neighbors({x, y, z, w}, 4) do
    for n_x <- (x - 1)..(x + 1),
        n_y <- (y - 1)..(y + 1),
        n_z <- (z - 1)..(z + 1),
        n_w <- (w - 1)..(w + 1),
        {n_x, n_y, n_z, n_w} != {x, y, z, w} do
      {n_x, n_y, n_z, n_w}
    end
  end

  def sum_up_neighbors(neighbors, cube) do
    Enum.reduce(
      neighbors,
      %{active: 0, inactive: 0},
      fn coord, %{active: active, inactive: inactive} ->
        case Map.get(cube, coord, :inactive) do
          :active -> %{active: active + 1, inactive: inactive}
          :inactive -> %{active: active, inactive: inactive + 1}
        end
      end
    )
  end

  def find_cube_domain(cube, 3) do
    {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}, _} =
      Enum.reduce(
        cube,
        {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
        fn {{x, y, z, w}, _}, {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}, {min_w, max_w}} ->
          {min_max({min_x, max_x}, x), min_max({min_y, max_y}, y), min_max({min_z, max_z}, z),
           min_max({min_w, max_w}, w)}
        end
      )

    {(min_x - 1)..(max_x + 1), (min_y - 1)..(max_y + 1), (min_z - 1)..(max_z + 1), 0..0}
  end

  def find_cube_domain(cube, 4) do
    {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}, {min_w, max_w}} =
      Enum.reduce(
        cube,
        {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
        fn {{x, y, z, w}, _}, {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}, {min_w, max_w}} ->
          {min_max({min_x, max_x}, x), min_max({min_y, max_y}, y), min_max({min_z, max_z}, z),
           min_max({min_w, max_w}, w)}
        end
      )

    {(min_x - 1)..(max_x + 1), (min_y - 1)..(max_y + 1), (min_z - 1)..(max_z + 1),
     (min_w - 1)..(max_w + 1)}
  end

  def min_max({min, max}, new) do
    cond do
      new < min -> {new, max}
      new > max -> {min, new}
      true -> {min, max}
    end
  end

  def parse_args(args) do
    z = 0
    w = 0

    args
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        case char do
          "." -> {{x, y, z, w}, :inactive}
          "#" -> {{x, y, z, w}, :active}
        end
      end)
    end)
    |> Map.new()
  end
end
