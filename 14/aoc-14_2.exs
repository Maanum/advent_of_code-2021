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

    first_element = String.first(template)
    process_step(seeded_count_list, rules_list, first_element, 0)
  end

  def update_count_list([], count_list) do
    count_list
  end

  def update_count_list([head | tail], count_list) do
    update_count_list(tail, Map.put(count_list, head, count_list[head] + 1))
  end

  def process_step(result,_,first_element, 40) do
    my_new_map = Enum.reduce(result, %{}, fn {k,v}, acc ->
      [_, k2] = String.graphemes(k)
      acc = Map.put_new(acc, k2, 0)
      Map.put(acc, k2, v + acc[k2])
    end)
    counts = Map.put(my_new_map, first_element, my_new_map[first_element] + 1)
    |> Map.values
    |> Enum.sort

    result = List.last(counts) - List.first(counts)
    IO.inspect result
  end

  def process_step(count_list, rules_list, first_element, iter) do
    my_new_map = Enum.reduce(count_list, %{}, fn {k,v}, acc ->
      [ update_val_1,  update_val_2 ] = rules_list[k]
      acc = Map.put_new(acc, update_val_1, 0)
      acc = Map.put_new(acc, update_val_2, 0)
      acc = Map.put(acc, update_val_1, v + acc[update_val_1])
      Map.put(acc, update_val_2, v + acc[update_val_2])
    end)

    process_step(my_new_map, rules_list, first_element, iter + 1)
  end


end

MyScript.polymer
