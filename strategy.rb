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
    if my.armor <= 3
      if !@last_move || @last_move == :fire
        @last_move = :dance
        dance
      elsif @last_move == :dance
        @last_move = :aim
        aim_at! enemy
      elsif @last_move = :aim
        @last_move = :fire
        fire!((-1..1).to_a.shuffle.first)
      end
    else
      if my.ammo == 0
        rest
      elsif !enemy
        dance
      elsif obscured? enemy
        move_towards! enemy
      elsif can_fire_at? enemy
        fire!((-2..2).to_a.shuffle.first)
      else
        aim_at! enemy
      end
    end
  end
end

include DalekSec

on_turn do
  dalek_turn
end
