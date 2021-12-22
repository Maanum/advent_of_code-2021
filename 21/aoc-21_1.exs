defmodule MyScript do
  def dirac_dice do
    positions = [ 9, 10 ]
    # positions = [ 4, 8 ]
    scores = [ 0, 0 ]
    dice = Enum.to_list(1..10000)
    |> Enum.chunk_every(3)

    next_round(positions, scores, dice, 1)

  end

  def next_round(positions, scores, dice, turn) do
    player = if rem(turn, 2) == 0, do: 1, else: 0
    [ roll | dice_tail ] = dice
    total_roll = Enum.sum(roll)

    my_modulo = rem(Enum.at(positions, player) + total_roll, 10)
    new_position = if my_modulo == 0, do: 10, else: my_modulo
    new_score = new_position + Enum.at(scores,player)

    new_positions = List.replace_at(positions, player, new_position)
    new_scores = List.replace_at(scores, player, new_score)

    if Enum.max(new_scores) > 999 do
      calc_totals(new_scores, turn)
    else
      next_round(new_positions, new_scores, dice_tail, turn + 1)
    end
  end


  def calc_totals(scores, turn) do
    rolls = turn * 3
    loser_score = Enum.min(scores)
    IO.puts "Rolls #{rolls}"
    IO.inspect scores
    IO.inspect loser_score * rolls
  end
end

MyScript.dirac_dice
