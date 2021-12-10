defmodule MyScript do
  def smoke_basin do
    # GET INPUT

    {:ok, input} = File.read("input.txt")
    input = String.split(input, "\n", trim: true)
    |> Enum.map(fn x ->
      String.graphemes(x)
      |> Enum.map(fn item -> String.to_integer(item) end)
    end)

    # input_length = length(input)
    # input_width = length(List.first(input))

    low_points = for y_index <- 0..99 do
      for x_index <- 0..99 do
        if get_i(input, x_index, y_index) < get_i(input, x_index - 1, y_index) and
          get_i(input, x_index, y_index) < get_i(input, x_index + 1, y_index) and
          get_i(input, x_index, y_index) < get_i(input, x_index, y_index - 1) and
          get_i(input, x_index, y_index) < get_i(input, x_index, y_index + 1) do
            # { get_i(input, x_index, y_index), get_i(input, x_index, y_index) + 1 }
            get_i(input, x_index, y_index) + 1
          else
            # { get_i(input, x_index, y_index), 0 }
            0
          end
      end
    end

    count = Enum.map(low_points, fn x -> Enum.sum(x) end)
    |> Enum.sum
    IO.puts count
    # IO.inspect Enum.take(low_points, -5)


  end

  def get_i(my_list,x,y) do
    if x < 0 or x > 99 or y < 0 or y > 99 do
      99
    else
      Enum.at(Enum.at(my_list, y), x)
    end

  end
end

MyScript.smoke_basin
