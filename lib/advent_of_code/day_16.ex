defmodule AdventOfCode.Day16 do
  def part1(args) do
    {named_constraints, _ticket, nearby} = parse_args(args)

    constraints = named_constraints |> Enum.flat_map(fn {_, ranges} -> ranges end)

    nearby
    |> Enum.flat_map(& &1)
    |> Enum.filter(fn seat ->
      !Enum.any?(constraints, fn range -> Enum.member?(range, seat) end)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    {named_constraints, ticket, nearby} = parse_args(args)

    cols =
      nearby
      |> remove_invalid_ticket(named_constraints)
      |> into_cols([], -1)

    cols
    |> Enum.with_index()
    |> Enum.map(fn {col, i} ->
      {i, valid_constraints_for_column(named_constraints, col)}
    end)
    |> match_constraint([])
    |> Enum.filter(fn {_col, name} -> name =~ "departure" end)
    |> Enum.reduce(1, fn {col, _}, acc ->
      Enum.at(ticket, col) * acc
    end)
  end

  def match_constraint(problem, result) do
    sorted = problem |> Enum.sort(fn {_, a}, {_, b} -> Enum.count(a) <= Enum.count(b) end)

    case sorted do
      [] ->
        result

      val ->
        {col, constraints} = hd(val)

        Enum.map(constraints, fn {solution_name, _ranges} = solution ->
          match_constraint(
            remove_solution_from_problem(problem, solution, col),
            [{col, solution_name} | result]
          )
        end)
        |> Enum.find(& &1)
    end
  end

  def remove_solution_from_problem(problem, solution, col) do
    problem
    |> Enum.filter(fn {i, _} -> i != col end)
    |> Enum.map(fn {i, constraints} -> {i, List.delete(constraints, solution)} end)
  end

  def remove_invalid_ticket(tickets, named_constraints) do
    constraints = named_constraints |> Enum.flat_map(fn {_, ranges} -> ranges end)
    Enum.filter(tickets, fn ticket -> ticket_valid?(constraints, ticket) end)
  end

  @spec valid_constraints_for_column(any, any) :: any
  def valid_constraints_for_column(constraints, col) do
    Enum.filter(constraints, fn {_constraint_name, ranges} ->
      Enum.all?(col, fn seat ->
        Enum.any?(ranges, fn range -> Enum.member?(range, seat) end)
      end)
    end)
  end

  def into_cols(_tickets, cols, 0) do
    Enum.reverse(cols)
  end

  def into_cols(tickets, cols, _) do
    {new_cols, new_tickets, nb_cols} =
      Enum.reduce(tickets, {[], [], 0}, fn [col | rest], {cols, ticket_rests, _} ->
        {[col | cols], [rest | ticket_rests], Enum.count(rest)}
      end)

    into_cols(new_tickets, [new_cols | cols], nb_cols)
  end

  def ticket_valid?(constraints, ticket) do
    Enum.all?(ticket, fn seat ->
      Enum.any?(constraints, fn range -> Enum.member?(range, seat) end)
    end)
  end

  def parse_args(args) do
    [constraints_str, ticket_str, nearby_str] = String.split(args, "\n\n", trim: true)

    constraints =
      constraints_str
      |> String.split("\n")
      |> Enum.map(fn line ->
        [constraint_name, constr] = String.split(line, ":")

        constraints_list =
          Regex.scan(~r/(\d+)-(\d+)/m, constr, capture: :all)
          |> Enum.map(fn [_, min, max] ->
            String.to_integer(min)..String.to_integer(max)
          end)

        {constraint_name, constraints_list}
      end)

    nearby = parse_tickets(nearby_str)
    [ticket] = parse_tickets(ticket_str)

    {constraints, ticket, nearby}
  end

  def parse_tickets(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(fn line ->
      Regex.scan(~r/(\d+)/m, line, capture: :all)
      |> Enum.map(fn [_, seat] ->
        String.to_integer(seat)
      end)
    end)
  end
end
