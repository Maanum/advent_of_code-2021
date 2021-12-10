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
    |> Enum.reject(fn x -> String.contains?(x, [")", ">", "]", "}"]) end)
    |> Enum.map(fn x -> get_value(String.reverse(x), 0) end)
    |> Enum.sort

    IO.inspect Enum.at(counts, round((length(counts)-1)/2))

  end

  def get_value("", value) do
    value
  end

  def get_value(line_segment, value) do
    value_map = %{
      "(" => 1,
      "[" => 2,
      "{" => 3,
      "<" => 4
    }

    { next_char, remaining } = String.split_at(line_segment, 1)

    new_value = ( value * 5 ) + value_map[next_char]
    get_value(remaining, new_value)
  end

end

MyScript.syntax_scoring
