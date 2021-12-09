defmodule MyScript do

  def signal_processer do
    # GET INPUT

    {:ok, input} = File.read("input.txt")
    log_data = String.split(input, "\n", trim: true)
    |> Enum.map(fn x ->
      [ head, tail ] = String.split(x, "|", trim: true)
      # { String.split(head, " ", trim: true), String.split(tail, " ", trim: true)}
      String.split(tail, " ", trim: true)
      # tail
    end)
    |> List.flatten()
    |> Enum.map(fn x -> String.length(x) end)
    |> Enum.frequencies()

    IO.puts log_data[2] + log_data[3] + log_data[4] + log_data[7]

  end
end

MyScript.signal_processer
