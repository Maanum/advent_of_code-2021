defmodule MyScript do
  def smoke_basin do
    {:ok, input} = File.read("input.txt")
    input = String.split(input, "\n", trim: true)
    |> Enum.map(fn x ->
      String.graphemes(x)
      |> Enum.map(fn
        "9" -> "x"
        _ -> 0
      end)
    end)
    check_next(input,0,0)
  end

  def check_next(my_list, _, 100) do
    results = my_list
    |> List.flatten
    |> Enum.reject(fn x -> x == "x" end)
    |> Enum.frequencies
    |> Map.values
    |> Enum.sort
    |> Enum.take(-3)
    |> Enum.product

    to_csv(my_list)

    IO.inspect results
  end

  def check_next(my_list, 100, y) do
    check_next(my_list, 0, y + 1)
  end

  def check_next(my_list, x, y) do
    if get_i(my_list, x, y) == 0 do
      new_list = mark_basin(my_list, (100 * x) + y, [{x, y}, {x+1,y}, {x-1,y}, {x,y+1}, {x,y-1}], [])
      check_next(new_list, x + 1, y)
    else
      check_next(my_list, x + 1, y)
    end
  end

  def mark_basin(my_list, _, [], _) do
    my_list
  end

  def mark_basin(my_list, marker, points_to_check, checked) do
    [ { x, y } | other_points ] = points_to_check

    if get_i(my_list, x, y) == 0 do
      new_line = List.replace_at(Enum.at(my_list, y), x, marker)
      my_list = List.replace_at(my_list, y, new_line)
      updated_points = Enum.reject([{x+1,y}, {x-1,y}, {x,y+1}, {x,y-1}| other_points], fn x -> x in checked end)
      mark_basin(my_list, marker, updated_points, [{ x, y } | checked])
    else
      mark_basin(my_list, marker, other_points, [{ x, y } | checked])
    end

  end

  def get_i(my_list,x,y) do
    if x < 0 or x > 99 or y < 0 or y > 99 do
      "x"
    else
      Enum.at(Enum.at(my_list, y), x)
    end
  end

  def to_csv(data) do
    col_sep = ","
    row_sep = "\n"
    csv =
      for row <- data, into: "" do
        Enum.join(row, col_sep) <> row_sep
      end
    File.write!("results.csv", csv)
  end
end

MyScript.smoke_basin
