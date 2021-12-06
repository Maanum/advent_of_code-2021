defmodule MyScript do

  def laternfish do
    # GET INPUT
    {:ok, input} = File.read("input.txt")
    lantern_list = String.split(input, ",")
    |> Enum.map(fn x -> String.to_integer(x) end)

    # Process
    days_to_process = 80
    process_day(lantern_list, days_to_process)
  end

  def process_day(fish, 0) do
    IO.puts length(fish)
  end

  def process_day(fish, iter) do
    fish_advanced = Enum.map(fish, fn x -> x - 1 end)
    fish_add_new = fish_advanced ++ List.duplicate(8, Enum.count(fish_advanced, fn x -> x == -1 end))
    fish_reset_old = Enum.map(fish_add_new, fn
      -1 -> 6
      other -> other
    end)

    process_day(fish_reset_old, iter - 1)
  end
end

MyScript.laternfish
