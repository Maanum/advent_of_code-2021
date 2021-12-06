defmodule MyScript do

  def squid_game do
    # GET INPUT
    {:ok, input} = File.read("input.txt")
    [ numbers | boards ] = input |> String.split("\n", trim: true)

    number_list = numbers
    |> String.split(",", trim: true)
    |> Enum.map(fn y -> Integer.parse(y) |> elem(0) end)

    # CREATE BOARDS
    full_boards = boards
    |> Enum.map(fn x -> String.split(x) end)
    |> Enum.map(fn x -> Enum.map(x, fn y -> Integer.parse(y) |> elem(0) end) end)
    |> Enum.chunk_every(5)
    |> Enum.map(&add_columns/1)

    # EVALUATE GAME
    next_round(number_list, full_boards)
  end


  ### EVALUATE GAME, Helpers ###

  def next_round([round_number | remaining_numbers], boards) do
    updated_boards = for board <- boards do
      for solution <- board do
        Enum.reject(solution, fn x -> x == round_number end)
      end
    end

    if length(updated_boards) == 1 do
      get_winners(updated_boards, round_number)
      next_round(remaining_numbers, updated_boards)
    else
      cleaned = Enum.reject(updated_boards, fn x -> Enum.member?(x, []) end)
      next_round(remaining_numbers, cleaned)
    end
  end

  def get_winners(boards, number) do
    boards
    |> Enum.each(fn board ->
      if Enum.member?(board, []) do
        IO.inspect board

        # drop the column solutions
        # (to eliminate duplicate numbers)
        # then calculate total
        board_total = board
        |> Enum.drop(-5)
        |> Enum.map(fn x -> Enum.sum(x) end)
        |> Enum.sum

        score = board_total * number
        IO.puts(score)
        Process.exit(self, :normal)
      end
    end)
  end

  ### Set up boards, Helpers ###
  def get_single_column(this_list, column) do
    Enum.map(this_list, fn x -> Enum.at(x, column) end)
  end

  def get_column_solutions(my_list) do
    0..4
    |> Enum.map(&(get_single_column(my_list, &1)))
  end

  def add_columns(my_list) do
    get_column_solutions(my_list) ++ my_list
  end

end

MyScript.squid_game
