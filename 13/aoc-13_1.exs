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
    IO.inspect dots_list
    IO.inspect length(dots_list)
  end

  def execute_fold(dots_list, [ head_instruction | remaining_instructions ]) do
    { axis, position } = head_instruction
    new_dots = Enum.map(dots_list, fn {x,y} ->
      cond do
        axis == "x" and x > position ->
          {Kernel.abs(x - (position * 2)), y}
        axis == "y" and y > position ->
          {x, Kernel.abs(y - (position * 2))}
        true ->
          {x, y}
      end
    end)

    cleaned_dots = new_dots
    |> Enum.sort
    |> Enum.dedup

    execute_fold(cleaned_dots, [])
    # execute_fold(cleaned_dots, remaining_instructions)
  end
end

MyScript.folds
