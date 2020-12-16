defmodule AdventOfCode.Day14 do
  use Bitwise

  def part1(args) do
    args
    |> parse_args()
    |> Enum.reduce(%{mask_0: 0, mask_1: 0, mask_x: 0, register: %{}}, fn line, acc ->
      parse_line(line, acc)
    end)
    |> Map.get(:register)
    |> Enum.reduce(0, fn {_key, val}, acc -> val + acc end)
  end

  def parse_line(line, state)
      when binary_part(line, 0, 4) == "mask" do
    {mask_0, mask_1, mask_x} =
      line
      |> String.slice(7..-1)
      |> parse_mask()

    %{state | mask_0: ~~~mask_0, mask_1: mask_1, mask_x: mask_x}
  end

  def parse_line(line, %{mask_0: mask_0, mask_1: mask_1, register: register} = state)
      when binary_part(line, 0, 3) == "mem" do
    [_, addr, _, _, _, val] = String.split(line, ["[", "]", " ", "="])

    new_register = Map.put(register, addr, (String.to_integer(val) &&& mask_0) ||| mask_1)

    %{state | register: new_register}
  end

  defp parse_mask(mask) do
    mask
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce({0, 0, 0}, fn {elt, index}, {mask_0, mask_1, mask_x} ->
      case elt do
        "X" ->
          {mask_0, mask_1, mask_x ||| 1 <<< index}

        "0" ->
          {mask_0 ||| 1 <<< index, mask_1, mask_x}

        "1" ->
          {mask_0, mask_1 ||| 1 <<< index, mask_x}
      end
    end)
  end

  def part2(args) do
    args
    |> parse_args()
    |> Enum.reduce(%{masks: [], mask_1: 0, register: %{}}, fn line, acc ->
      parse_line_part2(line, acc)
    end)
    |> Map.get(:register)
    |> Enum.reduce(0, fn {_key, val}, acc -> val + acc end)
  end

  def parse_line_part2(line, state) when binary_part(line, 0, 4) == "mask" do
    mask =
      line
      |> String.slice(7..-1)
      |> String.graphemes()
      |> Enum.reverse()

    mask_1 = parse_mask_1(mask, 0)

    mask_x = parse_mask_x(mask, 0) |> Enum.map(&scenarii_to_masks(&1))

    %{state | masks: mask_x, mask_1: mask_1}
  end

  def parse_line_part2(line, %{masks: masks, mask_1: mask_1, register: register} = state)
      when binary_part(line, 0, 3) == "mem" do
    [_, addr, _, _, _, val] = String.split(line, ["[", "]", " ", "="])

    addr = String.to_integer(addr) ||| mask_1
    val = String.to_integer(val)

    new_register =
      masks
      |> Enum.map(fn {mask0, mask1} -> (addr ||| mask1) &&& mask0 end)
      |> Enum.reduce(register, fn addr, register ->
        Map.put(register, addr, val)
      end)

    %{state | register: new_register}
  end

  def scenarii_to_masks(scenarii) do
    {zero, one} =
      scenarii
      |> Enum.reduce({0, 0}, fn {action, val}, {zeroes, ones} ->
        case action do
          :zero -> {zeroes + val, ones}
          :one -> {zeroes, ones + val}
        end
      end)

    {~~~zero, one}
  end

  @spec parse_mask_1([any], any) :: non_neg_integer
  def parse_mask_1([char | mask], offset) when char == "1" do
    parse_mask_1(mask, offset + 1) + (1 <<< offset)
  end

  def parse_mask_1([_char | mask], offset), do: parse_mask_1(mask, offset + 1)

  def parse_mask_1([], _offset), do: 0

  def parse_mask_x([char | mask], offset) when char == "X" do
    scenarii = parse_mask_x(mask, offset + 1)

    add_to_scenario({:one, 1 <<< offset}, scenarii) ++
      add_to_scenario({:zero, 1 <<< offset}, scenarii)
  end

  def parse_mask_x([_char | mask], offset),
    do: parse_mask_x(mask, offset + 1)

  def parse_mask_x([], _offset) do
    []
  end

  def add_to_scenario(step, []) do
    [[step]]
  end

  def add_to_scenario(step, scenarii) do
    Enum.map(scenarii, fn scenario ->
      [step | scenario]
    end)
  end

  def parse_args(args) do
    args
    |> String.trim()
    |> String.split("\n")
  end
end
