defmodule MyScript do

  def laternfish do
    # GET INPUT

    {:ok, input} = File.read("input.txt")
    fish = String.split(input, ",")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.frequencies
    |> Map.merge(%{6 => 0,0 => 0, 7 => 0, 8 => 0})

    starting_fish =
    [
      Map.get(fish, 0),
      Map.get(fish, 1),
      Map.get(fish, 2),
      Map.get(fish, 3),
      Map.get(fish, 4),
      Map.get(fish, 5),
      Map.get(fish, 6),
      Map.get(fish, 7),
      Map.get(fish, 8)
    ]

    IO.inspect starting_fish

    # PROCESS

    # Part One
    # days_to_process = 80

    # Part Two
    days_to_process = 256

    process_day(starting_fish, days_to_process)
  end

  def process_day(fish, 0) do
    total = Enum.sum(fish)
    IO.puts total
  end

  def process_day([ zero | other ], iter) do
    new_fish = List.flatten([ other | [ zero ] ])
    |> List.update_at(6, &(&1 + zero))
    process_day(new_fish, iter - 1)
  end

end

MyScript.laternfish
