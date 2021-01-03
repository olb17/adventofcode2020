defmodule AdventOfCode.Day19 do
  def part1(args) do
    process(args, &Function.identity/1)
  end

  def part2(args) do
    process(args, &alter_rules_part2/1)
  end

  def process(args, alter_rules_fun) do
    {rules, lines} = parse_args(args) |> alter_rules_fun.()

    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&parse(&1, ["0"], rules))
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def alter_rules_part2({rules, lines}) do
    {build_rules(["8: 42 | 42 8", "11: 42 31 | 42 11 31"], rules), lines}
  end

  def parse_args(args) do
    [rule_defs, lines] = String.split(args, "\n\n", trim: true)

    {
      build_rules(String.split(rule_defs, "\n", trim: true), Map.new()),
      String.split(lines, "\n", trim: true)
    }
  end

  def build_rules([rule_def | rest], rules) do
    [id, rule_expr] = String.split(rule_def, ": ", trim: true)
    rule = build_specific_rule(rule_expr)
    build_rules(rest, Map.put(rules, id, rule))
  end

  def build_rules([], rules) do
    rules
  end

  def build_specific_rule(rule_expr) when binary_part(rule_expr, 0, 1) == "\"" do
    {:char, String.graphemes(rule_expr) |> Enum.at(1)}
  end

  def build_specific_rule(rule_expr) do
    String.split(rule_expr, "|", trim: true)
    |> Enum.map(fn subrule ->
      String.split(subrule, " ", trim: true)
    end)
  end

  def parse([char | rest] = str, [stack_rule_id | rest_stacked_rules_id], rules) do
    case Map.get(rules, stack_rule_id, nil) do
      {:char, rule_char} ->
        if rule_char == char do
          parse(rest, rest_stacked_rules_id, rules)
        else
          false
        end

      subrules ->
        Enum.any?(subrules, fn subrule ->
          parse(str, subrule ++ rest_stacked_rules_id, rules)
        end)
    end
  end

  def parse([], [], _), do: true

  def parse(_, _, _), do: false
end
