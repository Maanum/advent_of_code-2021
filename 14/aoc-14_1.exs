defmodule MyScript do
  def polymer do
    {:ok, input} = File.read("input.txt")

    [ template, rules ] = input
    |> String.split("\n\n", trim: true)

    rules_list = rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " -> ", trim: true) end)
    |> Map.new(fn [pair, element] -> { pair, String.first(pair) <> element <> String.last(pair) } end)

    # IO.inspect template
    # IO.inspect rules_list

    process_step(template, rules_list, 0)
  end

  def process_step(template,_,40) do
    count = String.graphemes(template)
    |> Enum.frequencies
    |> Map.values
    |> Enum.sort

    result = List.last(count) - List.first(count)

    IO.inspect result


  end

  def process_step(template, rules_list, iter) do
    IO.puts iter
    new_list = for x <- 0..String.length(template) - 2, do: String.slice(template, x, 2)
    add_elements = new_list
    |> Enum.map(fn x -> String.slice(rules_list[x], 1,2) end)
    |> Enum.join

    full_new_template = String.first(template) <> add_elements

    process_step(full_new_template, rules_list, iter + 1)
  end
end

MyScript.polymer
