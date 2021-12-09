defmodule MyScript do

  def signal_processer do


    # GET INPUT

    {:ok, input} = File.read("input.txt")
    log_data = String.split(input, "\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, "|", trim: true)
    end)

    new_data = Enum.map(log_data, fn x -> big_calc(x) end)
    IO.inspect Enum.sum(new_data)

  end

  def big_calc([log, entry]) do
    input = log
    |> String.split()
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)

    vals = %{}
    vals = Map.put_new(vals, 1, Enum.find(input, fn x -> length(x) == 2 end))
    vals = Map.put_new(vals, 4, Enum.find(input, fn x -> length(x) == 4 end))
    vals = Map.put_new(vals, 7, Enum.find(input, fn x -> length(x) == 3 end))
    vals = Map.put_new(vals, 8, Enum.find(input, fn x -> length(x) == 7 end))
    vals = Map.put_new(vals, 9, Enum.find(input, fn x ->
      length(x) == 6 and MapSet.subset?(MapSet.new(vals[4]), MapSet.new(x))
    end))
    vals = Map.put_new(vals, 3, Enum.find(input, fn x ->
      length(x) == 5 and MapSet.subset?(MapSet.new(vals[1]), MapSet.new(x))
    end))
    vals = Map.put_new(vals, 5, Enum.find(input, fn x ->
      length(x) == 5 and MapSet.subset?(MapSet.new(x), MapSet.new(vals[9])) and x != vals[3]
    end))
    vals = Map.put_new(vals, 2, Enum.find(input, fn x ->
      length(x) == 5 and x != vals[5] and x != vals[3]
    end))
    vals = Map.put_new(vals, 6, Enum.find(input, fn x ->
      length(x) == 6 and MapSet.subset?(MapSet.new(vals[5]), MapSet.new(x)) and x != vals[9]
    end))
    vals = Map.put_new(vals, 0, Enum.find(input, fn x ->
      length(x) == 6 and x != vals[9] and x != vals[6]
    end))

    my_map = Enum.map(vals, fn {x,y} -> { Enum.join(Enum.sort(y)), x } end)
    |> Enum.into(%{})

    my_list = entry
    |> String.split()
    |> Enum.map(fn x ->
      String.split(x, "", trim: true)
      |> Enum.sort
      |> Enum.join
    end)
    |> Enum.map(fn x -> my_map[x] end)
    |> Enum.join
    |> String.to_integer
    if Enum.count(my_map) != 10 do
      IO.inspect log
      IO.inspect entry
      IO.inspect my_map
      IO.puts my_list
    end

    my_list
  end

end

MyScript.signal_processer
