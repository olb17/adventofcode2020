defmodule AdventOfCode.Day07 do
  def part1(args) do
    map_contained_in =
      args
      |> String.trim()
      |> String.split(["\n"])
      |> Enum.map(&analyse_line(&1))
      |> Enum.reduce(%{}, fn elt, acc ->
        [container | rest] = elt

        rest
        |> Enum.reduce(acc, fn contained, acc ->
          {_, map} =
            Map.get_and_update(acc, contained, fn value ->
              case value do
                nil ->
                  {nil, [container]}

                bags ->
                  if Enum.member?(bags, container) do
                    {nil, value}
                  else
                    {nil, [container | bags]}
                  end
              end
            end)

          map
        end)
      end)

    find_bags_part1(map_contained_in, ["shiny gold"], [])
    |> Enum.count()
  end

  def part2(args) do
    map_contains =
      args
      |> String.trim()
      |> String.split(["\n"])
      |> Enum.map(&analyse_line_with_number(&1))
      |> Map.new()

    # remove "shiny gold count"
    count_inner_bags("shiny gold", map_contains) - 1
  end

  def find_bags_part1(map, [bag | bags_to_search], bags_container) do
    case Map.get(map, bag) do
      nil ->
        find_bags_part1(map, bags_to_search, bags_container)

      containers ->
        bags =
          Enum.filter(
            containers,
            &(!Enum.member?(bags_container, &1) && !Enum.member?(bags_to_search, &1))
          )

        find_bags_part1(
          map,
          Enum.concat([bags_to_search, bags]),
          Enum.concat([bags_container, bags])
        )
    end
  end

  def find_bags_part1(_map, [], bags_container) do
    bags_container
  end

  def analyse_line(line) do
    ("1 " <> line)
    |> String.split([" bags contain ", " bags, ", " bag, ", " bags.", " bag."])
    |> Enum.slice(0..-2)
    |> Enum.map(fn bag_with_number ->
      String.slice(bag_with_number, 2..-1)
    end)
  end

  def analyse_line_with_number(line) do
    [key | contains] =
      line
      |> String.split([" bags contain ", " bags, ", " bag, ", " bags.", " bag."])
      |> Enum.slice(0..-2)
      |> Enum.with_index()
      |> Enum.map(fn {bag, index} ->
        cond do
          index == 0 ->
            bag

          bag == "no other" ->
            nil

          true ->
            nb = String.slice(bag, 0..2) |> String.trim() |> Integer.parse() |> elem(0)
            bag = String.slice(bag, 2..-1)
            {nb, bag}
        end
      end)
      |> Enum.filter(&(&1 != nil))

    {key, contains}
  end

  def count_inner_bags(bag, map) do
    Enum.reduce(map[bag], 0, fn {nb, subbag}, acc ->
      count_inner_bags(subbag, map) * nb + acc
    end) + 1
  end
end
