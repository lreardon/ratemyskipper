class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def create_skipper(firstname, lastname, boatname, fishery, active)
    throw AlreadyExistsError if Skipper.find_by({ firstname:, lastname:, boatname:, fishery:, active: })

    Skipper.create(firstname, lastname, boatname, fishery, active)
  end
end
