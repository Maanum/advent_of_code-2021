defmodule MyScript do
  def folds do
    {:ok, input} = File.read("input.txt")

    [ dots, instructions ] = input
    |> String.split("\n\n", trim: true)

    dots_list = dots
    |> String.split("\n", trim: true)
    |> Enum.map(fn item ->
      [x,y] = String.split(item, ",")
      {String.to_integer(x), String.to_integer(y)}
    end)

    instructions_list = instructions
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, "=", trim: true) end)
    |> Enum.map(fn [axis, position] -> { String.replace(axis, "fold along ", ""), String.to_integer(position) } end)

    execute_fold(dots_list, instructions_list)
  end

  def execute_fold(dots_list, []) do
    x_max = (dots_list |> Enum.map(fn {x,_} -> x end) |> Enum.max) + 1
    y_max = dots_list |> Enum.map(fn {_,y} -> y end) |> Enum.max
    my_map = for y <- 0..y_max, into: %{}, do: {y, String.duplicate(" ", x_max)}
    update_sheet(dots_list, my_map, x_max)
  end

  def execute_fold(dots_list, [ head_instruction | remaining_instructions ]) do
    { axis, position } = head_instruction
    new_dots = dots_list
    |> Enum.map(fn {x,y} ->
      cond do
        axis == "x" and x > position ->
          {Kernel.abs(x - (position * 2)), y}
        axis == "y" and y > position ->
          {x, Kernel.abs(y - (position * 2))}
        true ->
          {x, y}
      end
    end)
    |> Enum.sort
    |> Enum.dedup

    execute_fold(new_dots, remaining_instructions)
  end

  def update_sheet([], code_map, _) do
    IO.inspect code_map
  end

  def update_sheet([head | tail], code_map, x_max) do
    {x, y} = head
    current_string = code_map[y]
    new_map = Map.replace(code_map, y, String.slice(current_string, 0..x) <> "█" <> String.slice(current_string, x+1..x_max))
    update_sheet(tail, new_map, x_max)
  end
end

MyScript.folds
