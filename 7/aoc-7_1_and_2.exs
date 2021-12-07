defmodule MyScript do

  def crab_subs do
    # GET INPUT

    {:ok, input} = File.read("input.txt")
    subs = String.split(input, ",")
    |> Enum.map(fn x -> String.to_integer(x) end)

    range_max = Enum.max(subs)

    results = for num <- 0..range_max do
      ### PART 1 ###
      # Enum.map(subs, fn x -> abs(num - x) end)
      ##############

      ### PART 2 ###
      Enum.map(subs, fn x ->
        Enum.to_list(0..abs(num - x))
        |> Enum.sum
      end)
      ##############
      |> Enum.sum
    end

    IO.inspect Enum.min(results)
  end
end

MyScript.crab_subs
