defmodule AdventOfCode.Day13 do
  def part1(args) do
    {target, ids} =
      args
      |> parse_args1()
      |> IO.inspect()

    {id, min} =
      ids
      |> Enum.map(&{&1, &1 - Kernel.rem(target, &1)})
      |> Enum.min_by(&elem(&1, 1))

    id * min
  end

  def parse_args1(args) do
    [target | instr] =
      args
      |> String.trim()
      |> String.split(["\n", ","])

    ids =
      instr
      |> Enum.map(fn elt ->
        if elt == "x", do: nil, else: String.to_integer(elt)
      end)
      |> Enum.filter(& &1)

    {target |> String.to_integer(), ids}
  end

  def part2(args) do
    [_, l2] = args |> String.split("\n") |> Enum.filter(&(&1 != "")) |> Enum.map(&String.trim/1)

    rules =
      l2
      |> String.split(",")
      |> Enum.with_index()
      |> Enum.filter(fn {v, _} -> v != "x" end)
      |> Enum.map(fn {v, i} -> {String.to_integer(v), -i} end)

    #      |> Enum.sort(&(elem(&1, 0) <= elem(&2, 0)))
    IO.inspect(rules)
    # first_time(1, rules) version semi brute
    chinese_remainder(rules)
  end

  @moduledoc """
  This module implements Chinese Remainder Theorem
  """

  @doc """
  Chinese Remainder Theorem.
  ## Example
    iex> AdventOfCode.Helpers.ChineseRemainder.chinese_remainder([{11, 10}, {12, 4}, {13, 12}])
    1000
    iex> AdventOfCode.Helpers.ChineseRemainder.chinese_remainder([{11, 10}, {22, 4}, {19, 9}])
    nil
    iex> AdventOfCode.Helpers.ChineseRemainder.chinese_remainder([{3, 2}, {5, 3}, {7, 2}])
    23
  """
  def chinese_remainder(congruences) do
    {modulii, residues} = Enum.unzip(congruences)
    mod_pi = Enum.reduce(modulii, 1, &Kernel.*/2)
    crt_modulii = Enum.map(modulii, &div(mod_pi, &1))

    case calculate_inverses(crt_modulii, modulii) do
      nil ->
        nil

      inverses ->
        crt_modulii
        |> Enum.zip(
          residues
          |> Enum.zip(inverses)
          |> Enum.map(fn {a, b} -> a * b end)
        )
        |> Enum.map(fn {a, b} -> a * b end)
        |> Enum.sum()
        |> mod(mod_pi)
    end
  end

  @doc """
  Calculates extended GCD
  ## Example
    iex> AdventOfCode.Helpers.ChineseRemainder.egcd(1914, 899)
    {8, -17}
    iex> AdventOfCode.Helpers.ChineseRemainder.egcd(1432, 123211)
    {-22973, 267}
  """
  def egcd(_, 0), do: {1, 0}

  def egcd(a, b) do
    {s, t} = egcd(b, rem(a, b))
    {t, s - div(a, b) * t}
  end

  defp mod_inverse(a, b) do
    {x, y} = egcd(a, b)
    (a * x + b * y == 1 && x) || nil
  end

  defp mod(a, m) do
    x = rem(a, m)
    (x < 0 && x + m) || x
  end

  defp calculate_inverses([], []), do: []

  defp calculate_inverses([n | ns], [m | ms]) do
    case mod_inverse(n, m) do
      nil -> nil
      inv -> [inv | calculate_inverses(ns, ms)]
    end
  end

  defp first_time(mtime, [{bus, delta}]) do
    if rem(mtime + delta, bus) == 0 do
      mtime
    else
      (div(mtime + delta, bus) + 1) * bus - delta
    end
  end

  defp first_time(mtime, [{bus, delta} | rest] = rules) do
    # IO.inspect({mtime, {bus, delta}})
    # :timer.sleep(10)
    if rem(mtime + delta, bus) == 0 do
      new_mtime = first_time(mtime, rest)

      if new_mtime == mtime do
        mtime
      else
        first_time(new_mtime, rules)
      end
    else
      first_time((div(mtime + delta, bus) + 1) * bus - delta, rules)
    end
  end

  defp parse(input) do
    [l1, l2] = input |> String.split("\n") |> Enum.filter(&(&1 != "")) |> Enum.map(&String.trim/1)

    {String.to_integer(l1),
     l2 |> String.split(",") |> Enum.filter(&(&1 != "x")) |> Enum.map(&String.to_integer/1)}
  end
end
