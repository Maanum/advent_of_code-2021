defmodule MyScript do

  def clouds do
    # GET INPUT
    {:ok, input} = File.read("input.txt")
    coords = parse_input(input)
    full_points_lists = fill_out_points(coords)

    counts = List.flatten(full_points_lists) # Flatten points into one list
    |> Enum.frequencies  # Get frequency of each point
    |> Map.values  # Put frequency values into list (don't need coord info)
    |> Enum.reject( fn x -> x < 2 end) # remove frequencies of < 2
    |> length # count remaining frequencies (remaining are >1)

    IO.puts counts
  end

  def parse_input(input) do
    input
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.split(x," -> ", trim: true) end)
      |> Enum.map(fn y -> Enum.map(y, fn item ->
        [x,y] = String.split(item, ",")
        {String.to_integer(x), String.to_integer(y)}
      end) end)
  end

  def fill_out_points(coords_list) do
    for coord_set <- coords_list do
      [{x1,y1},{x2,y2}] = coord_set

      # There's a more elegant way to do this.  No time, don't judge
      cond do
        x1 == x2 ->
          Enum.into y1..y2, [], &({x1, &1})
        y1 == y2 ->
          Enum.into x1..x2, [], &({&1, y1})
        x1 < x2 and y1 < y2 ->
          num = x2 - x1
          Enum.into 0..num, [], &({x1 + &1, y1 + &1})
        x1 > x2 and y1 > y2 ->
          num = x1 - x2
          Enum.into 0..num, [], &({x1 - &1, y1 - &1})
        x1 < x2 and y1 > y2 ->
          num = x2 - x1
          Enum.into 0..num, [], &({x1 + &1, y1 - &1})
        x1 > x2 and y1 < y2 ->
          num = x1 - x2
          Enum.into 0..num, [], &({x1 - &1, y1 + &1})
        true ->
          {0,0}
      end
    end
  end

end

MyScript.clouds
