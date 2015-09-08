class Ability
  include CanCan::Ability

  def initialize(user)


    user ||= User.new # guest user (not logged in)
    if user.admin == true
      can :manage, :all
    else
      can :read, Product
      can :manage, Order do |order|
        order.try(:user) == user
      end
    end
  end
end
