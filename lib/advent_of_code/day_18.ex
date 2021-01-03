defmodule AdventOfCode.Day18 do
  def part1(args) do
    args
    |> parse_args()
    |> Enum.map(fn tokens ->
      tokens
      |> build_tree()
      |> elem(1)
      |> evaluate_tree()
    end)
    |> Enum.sum()
  end

  def build_tree([token | rest]) do
    case token do
      {:digit, val} ->
        evaluate_lhs(rest, {:digit, val})

      :open ->
        {[:close | new_rest], new_val} = build_tree(rest)
        evaluate_lhs(new_rest, {:paren, new_val})
    end
  end

  def evaluate_lhs(rest, val) do
    case rest do
      [{:op, operation, type} | new_rest] ->
        {new_new_rest, new_val} = build_tree(new_rest)
        # {new_new_rest, operation.(val, new_val)}
        {new_new_rest, {:op, operation, val, new_val, type}}

      _ ->
        {rest, val}
    end
  end

  def evaluate_tree(
        {:op, operation, left, {:op, right_operation, right_left_val, right_right_val, type}, _}
      ) do
    left_val = evaluate_tree(left)
    right_val = evaluate_tree(right_left_val)
    subres = operation.(left_val, right_val)

    evaluate_tree({:op, right_operation, {:digit, subres}, right_right_val, type})
  end

  def evaluate_tree({:op, operation, left, right, _}) do
    left_val = evaluate_tree(left)
    right_val = evaluate_tree(right)
    operation.(left_val, right_val)
  end

  def evaluate_tree({:digit, val}) do
    val
  end

  def evaluate_tree({:paren, val}) do
    evaluate_tree(val)
  end

  def part2(args) do
    args
    |> parse_args()
    |> Enum.map(fn tokens ->
      tokens
      |> build_tree()
      |> elem(1)
      |> evaluate_tree2()
    end)
    |> Enum.sum()
  end

  def evaluate_tree2(
        {:op, operation, left,
         {:op, _right_operation, _right_left_val, _right_right_val, "+"} = op, "*"}
      ) do
    left_val = evaluate_tree2(left)
    right_val = evaluate_tree2(op)
    operation.(left_val, right_val)
  end

  def evaluate_tree2(
        {:op, operation, left,
         {:op, right_operation, right_left_val, right_right_val, right_type}, _left_type}
      ) do
    left_val = evaluate_tree2(left)
    right_val = evaluate_tree2(right_left_val)
    subres = operation.(left_val, right_val)

    evaluate_tree2({:op, right_operation, {:digit, subres}, right_right_val, right_type})
  end

  def evaluate_tree2({:op, operation, left, right, _}) do
    left_val = evaluate_tree2(left)
    right_val = evaluate_tree2(right)
    operation.(left_val, right_val)
  end

  def evaluate_tree2({:digit, val}) do
    val
  end

  def evaluate_tree2({:paren, val}) do
    evaluate_tree2(val)
  end

  def parse_args(args) do
    args
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(fn token ->
        case token do
          "*" -> {:op, &Kernel.*/2, "*"}
          "+" -> {:op, &Kernel.+/2, "+"}
          "(" -> :open
          ")" -> :close
          val -> {:digit, String.to_integer(val)}
        end
      end)
    end)
  end
end
