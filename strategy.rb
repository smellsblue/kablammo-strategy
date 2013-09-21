class DalekSec
  attr_accessor :mode

  def initialize(me)
    @mode = DalekSec::ExterminateMode.new self
  end

  def pick_mode!
    if desperate?
      mode = DalekSec::PanicMode.new self
    elsif low_ammo?
      mode = DalekSec::ReloadMode.new self
    else
      mode = DalekSec::ExterminateMode.new self
    end
  end

  def enemy
    opponents.first
  end

  def turn
    pick_mode! if mode.done?
    mode.turn
  end

  def desparate?
    my.armor <= 3
  end

  def low_ammo?
    my.ammo <= 3
  end

  class Mode
    attr_reader :me

    def initialize(me)
      @me = me
    end
  end

  class PanicMode < DalekSec::Mode
    def done?
      false
    end

    def turn
      if my.ammo == 0
        rest
      elsif obscured? enemy
        move_towards! enemy
      elsif can_fire_at? enemy
        fire! 0
      else
        aim_at! enemy
      end
    end
  end

  class ReloadMode < DalekSec::Mode
    def done?
      me.desperate? || my.ammo_full?
    end

    def turn
      rest
    end
  end

  class ExterminateMode < DalekSec::Mode
    def done?
      me.desperate? || me.low_ammo?
    end

    def turn
      if obscured? enemy
        move_towards! enemy
      elsif can_fire_at? enemy
        fire! 0
      else
        aim_at! enemy
      end
    end
  end
end

dalek_sec = DalekSec.new(self)

on_turn do
  dalek_sec.turn
end
