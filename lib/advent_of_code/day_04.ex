defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split(["\n\n"])
    |> Enum.map(fn p ->
      p
      |> String.trim()
      |> String.split(["\n", "\r", " "])
      |> Enum.reduce(%{}, fn attr, acc ->
        [key, value] = String.split(attr, [":"])
        Map.put(acc, key, value)
      end)
    end)
    |> Enum.filter(&is_passport_valid_part1/1)
    |> Enum.count()
  end

  defp is_passport_valid_part1(%{
         "byr" => _,
         "iyr" => _,
         "eyr" => _,
         "hgt" => _,
         "hcl" => _,
         "ecl" => _,
         "pid" => _
       }) do
    true
  end

  defp is_passport_valid_part1(_), do: false

  def part2(args) do
    args
    |> String.trim()
    |> String.split(["\n\n"])
    |> Enum.map(fn p ->
      p
      |> String.trim()
      |> String.split(["\n", "\r", " "])
      |> Enum.reduce(%{}, fn attr, acc ->
        [key, value] = String.split(attr, [":"])
        Map.put(acc, key, value)
      end)
    end)
    |> Enum.filter(&is_passport_valid_part2/1)
    |> Enum.count()
  end

  defp is_passport_valid_part2(%{
         "byr" => byr_str,
         "iyr" => iyr_str,
         "eyr" => eyr_str,
         "hgt" => hgt_str,
         "hcl" => hcl_str,
         "ecl" => ecl_str,
         "pid" => pid_str
       }) do
    [
      is_digits_between(byr_str, 4, 1920, 2002),
      is_digits_between(iyr_str, 4, 2010, 2020),
      is_digits_between(eyr_str, 4, 2020, 2030),
      is_height_valid(hgt_str),
      Regex.match?(~r/^#[0-9a-f]{6}$/, hcl_str),
      Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], ecl_str),
      Regex.match?(~r/^\d{9}$/, pid_str)
    ]
    |> Enum.all?(&(&1 == true))
  end

  defp is_passport_valid_part2(_), do: false

  defp is_height_valid(hgt_str) do
    case String.slice(hgt_str, -2..-1) do
      "cm" ->
        is_digits_between(String.slice(hgt_str, 0..-3), 150, 193)

      "in" ->
        is_digits_between(String.slice(hgt_str, 0..-3), 59, 76)

      _ ->
        false
    end
  end

  defp is_digits_between(str, _length, min, max) do
    if Regex.match?(~r/^\d\d\d\d$/, str) do
      is_digits_between(str, min, max)
    else
      false
    end
  end

  defp is_digits_between(str, min, max) do
    {value, _} = Integer.parse(str)
    value <= max && value >= min
  end
end
