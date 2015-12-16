module Para
  class Ability
    include CanCan::Ability

    def initialize(user)
      if user.is_a?(AdminUser)
        can :access, :admin
        can :manage, :all
      end
    end
  end
end
