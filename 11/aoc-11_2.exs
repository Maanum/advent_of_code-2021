defmodule MyScript do
  def octopus_flashing do
    {:ok, input} = File.read("input-test.txt")
    input = String.split(input, "\n", trim: true)
    |> Enum.map(fn x ->
      String.graphemes(x)
      |> Enum.map(fn item -> String.to_integer(item) end)
    end)

    mapped_lines = input
    |> Enum.map(fn x -> for {v, k} <- x |> Enum.with_index, into: %{}, do: {k, v} end)
    full_map = for {v, k} <- mapped_lines |> Enum.with_index, into: %{}, do: {k, v}
    next_step(full_map, 0, 0)
  end

  def next_step(octopi, flash_count, step) do
    octo_sum = octopi
    |> Map.map(fn {_key, sub_map} -> Map.values(sub_map) end)
    |> Map.values
    |> List.flatten
    |> Enum.sum

    if octo_sum == 0 do
      end_script(octopi, step)
    else
      new_octopi = octopi
      |> Map.map(fn {_key, sub_map} -> Map.map(sub_map, fn {_subkey, v} -> v + 1 end) end)
      update_flashes(new_octopi, flash_count, step, 0, 0)
    end
  end


  def update_flashes(octopi, flash_count, step, 10, _) do
    new_octopi = octopi
    |> Map.map(fn {_key, sub_map} -> Map.map(sub_map,fn {_subkey, v} -> if v < 0, do: 0, else: v end) end)

    next_step(new_octopi, flash_count, step + 1)
  end

  def update_flashes(octopi, flash_count, step, y, 10) do
    update_flashes(octopi, flash_count, step, y + 1 , 0)
  end

  def update_flashes(octopi, flash_count, step, y, x) do
    if octopi[y][x] > 9 do
      nearby = [{-1,-1},{-1,0},{-1,1},{0,-1},{0,1},{1,-1},{1,0},{1,1}]
      new_octopi = update_nearby(octopi, nearby, y, x)
      update_flashes(new_octopi, flash_count + 1, step, 0, 0)
    else
      update_flashes(octopi, flash_count, step, y, x + 1)
    end
  end

  def update_nearby(octopi, [], y, x) do
    put_in(octopi[y][x], -1000)
  end

  def update_nearby(octopi, [head | tail], y, x) do
    { y_mod, x_mod } = head
    if -1 < x + x_mod and x + x_mod < 10 and -1 < y + y_mod and y + y_mod < 10 do
      octopi = put_in(octopi[y+y_mod][x+x_mod], octopi[y+y_mod][x+x_mod] + 1)
      update_nearby(octopi, tail, y, x)
    else
      update_nearby(octopi, tail, y, x)
    end
  end

  def end_script(list, step) do
    IO.puts step
  end


end

MyScript.octopus_flashing
