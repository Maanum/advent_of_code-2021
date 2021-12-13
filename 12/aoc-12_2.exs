defmodule MyScript do
  def passage do
    {:ok, input} = File.read("input.txt")
    edges = String.split(input, "\n", trim: true)
    |> Enum.map(fn x -> String.split(x, "-", trim: true) end)

    nodes = edges
    |> List.flatten
    |> Enum.sort
    |> Enum.dedup
    |> Map.new(fn k -> {k, []} end)
    |> Map.map(fn {k, _}  ->
        Enum.filter(edges, fn edge -> Enum.member?(edge, k) end)
        |> List.flatten
        |> Enum.sort
        |> Enum.dedup
        |> Enum.reject(fn x -> x == k end)
      end)

    paths = [["start"]]
    next_node(paths, 0, nodes)
  end

  def next_node([], paths_count, _) do
    IO.puts paths_count
  end

  def next_node(paths, paths_count, nodes) do
    next_path_node = paths
    |> Enum.map(fn [last | tail] ->
      Enum.map(nodes[last], fn node ->
        if (!Enum.member?(tail, node) or String.upcase(node) == node or check_lower_frequency([last | tail])) and node != "start" do
          [node] ++ [last] ++ tail
        end
      end)
    end)
    |> Enum.concat
    |> Enum.reject(fn x -> x == nil end)

    paths_removed_completed = next_path_node |> Enum.reject(fn x -> Enum.member?(x, "end") end)
    new_paths_count = length(next_path_node) - length(paths_removed_completed)

    next_node(paths_removed_completed, paths_count + new_paths_count, nodes)
  end

  def check_lower_frequency(list) do
    most_frequent_lower = list
    |> Enum.reject(fn x -> x == "end" or x == "start" or String.upcase(x) == x end)
    |> Enum.frequencies
    |> Map.values
    |> Enum.max(fn -> 0 end)

    most_frequent_lower < 2
  end
end

MyScript.passage
