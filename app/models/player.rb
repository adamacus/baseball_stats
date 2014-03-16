class Player < ActiveRecord::Base

  attr_readonly :player_id, :birth_year, :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}".strip
  end

end
