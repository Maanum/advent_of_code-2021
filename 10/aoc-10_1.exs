defmodule MyScript do
  def syntax_scoring do
    {:ok, input} = File.read("input.txt")
    input = String.split(input, "\n", trim: true)

    simplify_string(input, false)
  end

  def simplify_string(list, false) do
    updated_list = list
    |> Enum.map(fn x -> String.replace(x, ["()", "<>", "[]", "{}"], fn _ -> "" end) end)
    simplify_string(updated_list, list == updated_list)
  end

  def simplify_string(list, true) do
    counts = list
    |> Enum.map(fn x -> String.replace(x, ["(", "<", "[", "{"], fn _ -> "" end) end)
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.map(fn x -> String.first(x) end)
    |> Enum.frequencies

    total =
      (counts[")"] * 3) +
      (counts["]"] * 57) +
      (counts["}"] * 1197) +
      (counts[">"] * 25137)

    IO.inspect total
  end
end

MyScript.syntax_scoring
