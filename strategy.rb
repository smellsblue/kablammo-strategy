module DalekSec
  def dance
    first_possible_move %w(n s e w).shuffle
  end

  def julia_hunt
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

  def fire_at!(enemy, compensate = 0)
    direction = robot.direction_to(enemy).round
    skew = direction - robot.rotation
    distance = robot.distance_to(enemy)
    max_distance = Math.sqrt(board.height * board.height + board.width * board.width)
    compensation = ( 10 - ( (10 - 3) * (distance / max_distance) ) ).round
    compensation *= -1 if rand(0..1) == 0
    skew += compensation if compensate > rand
    fire! skew
  end

  # I give up... too hard to debug without a workable local server and
  # no feedback from the live server that actually works :-(
  def dalek_turn
    if my.ammo == 0
      rest
    elsif !enemy
      dance
    elsif obscured? enemy
      move_towards! enemy
    elsif can_fire_at? enemy
      fire_at! enemy
    else
      aim_at! enemy
    end
  end
end

include DalekSec

on_turn do
  dalek_turn
end
