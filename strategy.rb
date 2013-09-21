module DalekSec
  def dance
    first_possible_move %w(n s e w).shuffle
  end

  def hunt
    x, y = robot.x, robot.y
    return first_possible_move 'nesw' if x == 0
    return first_possible_move 'eswn' if y == @battle.board.height - 1
    return first_possible_move 'swne' if x == @battle.board.width - 1
    return first_possible_move 'wnes' if y == 0
    first_possible_move 'wsen'
  end

  def enemy
    opponents.first
  end

  def low_ammo?
    my.ammo <= 3
  end

  def dalek_turn
    if my.ammo == 0
      rest
    elsif !enemy
      dance
    elsif obscured? enemy
      move_towards! enemy
    elsif can_fire_at? enemy
      fire! -1
    else
      aim_at! enemy
    end
  end
end

include DalekSec

on_turn do
  dalek_turn
end
