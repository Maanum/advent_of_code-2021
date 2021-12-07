defmodule MyScript do

  def laternfish do
    # GET INPUT
    {:ok, input} = File.read("input.txt")
    lantern_list = String.split(input, ",")
    |> Enum.map(fn x -> String.to_integer(x) end)

    # PROCESS

    # Part One
    days_to_process = 80

    # Part Two
    # days_to_process = 256

    process_day(lantern_list, days_to_process)
  end

  def process_day(fish, 0) do
    IO.puts length(fish)
  end

  def process_day(fish, iter) do
    IO.puts "Days Left: #{iter}"
    fish_at_zero = Enum.count(fish, fn x -> x == 0 end)
    fish_advanced = Stream.reject(fish, fn x -> x == 0 end)
    |> Enum.map(fn x -> x - 1 end)

    new_fish = [ List.duplicate(6, fish_at_zero) | [ List.duplicate(8, fish_at_zero) | fish_advanced ]]
    |> List.flatten()

    process_day(new_fish, iter - 1)
  end

    def process_day(fish, iter) do
    IO.puts "Days Left: #{iter}"
    fish_at_zero = Enum.count(fish, fn x -> x == 0 end)
    fish_advanced = Stream.reject(fish, fn x -> x == 0 end)
    |> Enum.map(fn x -> x - 1 end)

    new_fish = [ List.duplicate(6, fish_at_zero) | [ List.duplicate(8, fish_at_zero) | fish_advanced ]]
    |> List.flatten()

    process_day(new_fish, iter - 1)
  end

end

MyScript.laternfish
