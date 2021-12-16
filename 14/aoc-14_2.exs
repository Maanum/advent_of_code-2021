defmodule MyScript do
  def polymer do
    {:ok, input} = File.read("input.txt")

    [ template, rules ] = input
    |> String.split("\n\n", trim: true)

    rules_list = rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " -> ", trim: true) end)
    |> Map.new(fn [pair, element] -> {pair, [String.first(pair) <> element, element <> String.last(pair)] } end)

    set_list = for x <- 0..String.length(template) - 2, do: String.slice(template, x, 2)

    count_list = rules_list
    |> Map.keys
    |> Map.new(fn k -> {k, 0} end)

    seeded_count_list = update_count_list(set_list, count_list)
    process_step(seeded_count_list, rules_list, 0)
  end

  ### Slow
  def update_count_list([], count_list) do
    count_list
  end

  def update_count_list([head | tail], count_list) do
    update_count_list(tail, Map.put(count_list, head, count_list[head] + 1))
  end

  def process_step(template,_,100) do
    IO.inspect template
  end

  def process_step(count_list, rules_list, iter) do
    IO.puts iter

    new_set_list = Enum.map(count_list, fn {k, v} -> List.duplicate(rules_list[k],v) end) |> List.flatten()
    new_count_list = update_count_list(new_set_list, count_list)
    process_step(new_count_list, rules_list, iter + 1)
  end
  ###

  ### Faster than solution 1, not good enough
  # def process_step(template,_,100) do
  #   IO.inspect template
  # end

  # def process_step(set_list, rules_list, iter) do
  #   IO.puts iter

  #   add_elements = set_list
  #   |> Enum.map(fn x -> rules_list[x] end)
  #   |> List.flatten

  #   process_step(add_elements, rules_list, iter + 1)
  # end
  ###
end

MyScript.polymer
