defmodule AdventOfCode.Day08 do
  def part1(args) do
    program = load_program(args)
    execute(0, 0, MapSet.new(), program)
  end

  def part2(args) do
    program =
      args
      |> load_program()

    Enum.reduce_while(0..Enum.count(program), 0, fn _, addr ->
      case Map.get(program, addr) do
        {"nop", val} ->
          new_prog = Map.put(program, addr, {"jmp", val})
          check_execution(new_prog, addr)

        {"jmp", val} ->
          new_prog = Map.put(program, addr, {"nop", val})
          check_execution(new_prog, addr)

        _ ->
          {:cont, addr + 1}
      end
    end)
  end

  defp check_execution(program, addr) do
    case execute(0, 0, MapSet.new(), program) do
      {:ok, val} ->
        {:halt, val}

      {:error, _} ->
        {:cont, addr + 1}
    end
  end

  def execute(cur_instr_addr, acc, already_executed, program) do
    cond do
      MapSet.member?(already_executed, cur_instr_addr) ->
        {:error, acc}

      cur_instr_addr == Enum.count(program) ->
        {:ok, acc}

      true ->
        {next_instr_addr, new_acc} =
          execute_instr(Map.get(program, cur_instr_addr), cur_instr_addr, acc)

        new_executed = MapSet.put(already_executed, cur_instr_addr)
        execute(next_instr_addr, new_acc, new_executed, program)
    end
  end

  defp execute_instr({"acc", value}, addr, acc) do
    {addr + 1, acc + value}
  end

  defp execute_instr({"jmp", offset}, addr, acc) do
    {addr + offset, acc}
  end

  defp execute_instr({"nop", _}, addr, acc) do
    {addr + 1, acc}
  end

  def load_program(lines) do
    lines
    |> String.trim()
    |> String.split(["\n"])
    |> Enum.map(fn line ->
      cmd = String.slice(line, 0..2)
      arg = String.slice(line, 4..-1) |> Integer.parse() |> elem(0)
      {cmd, arg}
    end)
    |> Enum.with_index()
    |> Map.new(&{elem(&1, 1), elem(&1, 0)})
  end
end
