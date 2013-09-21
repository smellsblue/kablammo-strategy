#module DalekSec
#  attr_accessor :dalek_mode
#
#  def pick_mode!
#    if desperate?
#      self.dalek_mode = :panic
#    elsif low_ammo?
#      self.dalek_mode = :reload
#    else
#      self.dalek_mode = :exterminate
#    end
#  end
#
#  def mode_done?
#    case dalek_mode
#    when :panic
#      false
#    when :exterminate
#      desperate? || low_ammo?
#    when :reload
#      desperate? || my.ammo_full?
#    else
#      true
#    end
#  end
#
#  def dalek_mode_turn!
#    case dalek_mode
#    when :panic
#      panic_mode!
#    when :exterminate
#      exterminate_mode!
#    when :reload
#      reload_mode!
#    end
#  end
#
#  def dalek_turn
#    pick_mode! if mode_done?
#    dalek_mode_turn!
#  end
#
#  def enemy
#    opponents.first
#  end
#
#  def desperate?
#    my.armor <= 3
#  end
#
#  def low_ammo?
#    my.ammo <= 3
#  end
#
#  def panic_mode!
#    if my.ammo == 0
#      rest
#    elsif obscured? enemy
#      move_towards! enemy
#    elsif can_fire_at? enemy
#      fire! 0
#    else
#      aim_at! enemy
#    end
#  end
#
#  def exterminate_mode!
#    if obscured? enemy
#      move_towards! enemy
#    elsif can_fire_at? enemy
#      fire! 0
#    else
#      aim_at! enemy
#    end
#  end
#
#  def reload_mode!
#    rest
#  end
#end

module DalekSec
  attr_accessor :dalek_mode

  def dalek_turn
    if obscured? enemy
      move_towards! enemy
    elsif can_fire_at? enemy
      fire! 0
    else
      aim_at! enemy
    end
  end
end

include DalekSec
self.dalek_mode = :exterminate

on_turn do
  dalek_turn
end
