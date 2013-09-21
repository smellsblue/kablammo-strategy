module DalekSec
  attr_accessor :mode

  def initialize_dalek
    @mode = DalekSec::ExterminateMode.new self
  end

  def pick_mode!
    if desperate?
      self.mode = DalekSec::PanicMode.new self
    elsif low_ammo?
      self.mode = DalekSec::ReloadMode.new self
    else
      self.mode = DalekSec::ExterminateMode.new self
    end
  end

  def enemy
    opponents.first
  end

  def dalek_turn
    pick_mode! if mode.done?
    mode.turn
  end

  def desperate?
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
      if me.ammo == 0
        me.rest
      elsif me.obscured? enemy
        me.move_towards! enemy
      elsif me.can_fire_at? enemy
        me.fire! 0
      else
        me.aim_at! enemy
      end
    end
  end

  class ReloadMode < DalekSec::Mode
    def done?
      me.desperate? || me.ammo_full?
    end

    def turn
      me.rest
    end
  end

  class ExterminateMode < DalekSec::Mode
    def done?
      me.desperate? || me.low_ammo?
    end

    def turn
      if me.obscured? enemy
        me.move_towards! enemy
      elsif me.can_fire_at? enemy
        me.fire! 0
      else
        me.aim_at! enemy
      end
    end
  end
end

include DalekSec
initialize_dalek

on_turn do
  dalek_turn
end
