defmodule MyScript do


  def greater_than(ones, zeros) do
    if length(ones) >= length(zeros) do
      _return_list = ones
    else
      _return_list = zeros
    end
  end

  def less_than(ones, zeros) do
    if length(ones) < length(zeros) do
      _return_list = ones
    else
      _return_list = zeros
    end
  end

  def get_filtered([], _, _) do
    IO.puts "No more values! Check code."
    :shutdown
  end

  def get_filtered([ last_item ], _, _) do
    last_item
  end

  def get_filtered(remaining_list, position, comp_fxn) do
    ones = Enum.filter(remaining_list, fn(x) -> (String.slice(x, position, 1)) == "1" end)
    zeros = Enum.filter(remaining_list, fn(x) -> (String.slice(x, position, 1)) == "0" end)
    get_filtered(comp_fxn.(ones, zeros), position + 1, comp_fxn)
  end

  def main do
    {:ok, input} = File.read("input.txt")
    input_list = input |> String.split("\n", trim: true)

    o2_gen = get_filtered(input_list, 0, &greater_than/2)
    co2_scrub = get_filtered(input_list, 0, &less_than/2)

    IO.puts ~s(o2 generator rating: #{o2_gen})
    IO.puts ~s(co2 scrubber rating: #{co2_scrub})
  end
end

MyScript.main
