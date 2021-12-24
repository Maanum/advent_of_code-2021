defmodule MyScript do
  def dirac_dice do
    # positions = [ 9, 10 ]
    positions = [ 4, 8 ]
    scores = [ 0, 0 ]
    games_map = %{ { positions, scores } => 1 }
    dice = [
      {3, 1},
      {4, 3},
      {5, 6},
      {6, 7},
      {7, 6},
      {8, 3},
      {9, 1}
    ]

    next_die(games_map, %{}, dice, dice, 0, 0)
  end

  # def next_die(_, games_map, _, _, _, 14) do
  #   IO.inspect games_map
  #   IO.inspect games_map
  #     |> Map.values
  #     |> Enum.sum
  # end


  def next_die(_, games_map, dice_options, [], player, round) do
    lowest_max_score = games_map
    |> Map.keys
    |> Enum.map(fn {_, score } -> Enum.max(score) end)
    |> Enum.min

    total_universes = games_map
      |> Map.values
      |> Enum.sum

    IO.puts "Universes: #{total_universes}, Lowest Score: #{lowest_max_score}"
    # IO.puts round
    # IO.inspect games_map |> Map.keys
    if lowest_max_score > 20 do
      IO.inspect games_map
      |> Map.values
      |> Enum.sum
    else
      next_player = if player == 0, do: 1, else: 0
      next_die(games_map, %{}, dice_options, dice_options, next_player, round + 1)
    end
  end

  def next_die(games_map, running_games_map, dice_options, [ next_die | remaining_dice ], player, round) do
    { die_value, results_count } = next_die

    new_games_map = Enum.reduce(games_map, running_games_map, fn {game_state, state_count}, acc ->
      { positions, scores } = game_state
      if Enum.max(scores) > 20 do
        acc = Map.put_new(acc, game_state, 0)
        Map.put(acc, game_state, state_count + acc[game_state])
      else
        my_modulo = rem(Enum.at(positions, player) + die_value, 10)
        new_position = if my_modulo == 0, do: 10, else: my_modulo
        new_score = new_position + Enum.at(scores, player)

        new_positions = List.replace_at(positions, player, new_position)
        new_scores = List.replace_at(scores, player, new_score)
        new_state = { new_positions, new_scores }
        acc = Map.put_new(acc, new_state, 0)
        new_state_count = (state_count * results_count) + acc[new_state]
        Map.put(acc, new_state, new_state_count)
      end
    end)
    next_die(games_map, new_games_map, dice_options, remaining_dice, player, round + 1)
  end

end

MyScript.dirac_dice
