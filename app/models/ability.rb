class Ability
  include CanCan::Ability

 def initialize(user)
   alias_action :create, :read, :update, :destroy, to: :crud
   alias_action :create, :read, :update, to: :cru

    user ||= User.new # guest user (not logged in)
    
      if user.role? :superadmin
        #superadmin can manage all
          can :manage, :all
          can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "superadmin"
      elsif user.role? :administrator
          can :read, :all
          can :manage, User
          can :manage, Vial
          can :manage, Position
          can :manage, Box
          can :manage, BoxType
          can :manage, Color
          cannot :manage, ContainerType
          cannot :manage, Location
          cannot :manage, Organization
          can :update, Container
          can :update, RackPosition
          can :update, ShelfRack
     elsif user.role? :user
          can :read, :all
          can :manage, Vial
          can :manage, Position
          can :manage, Box
          can :update, Option
          cannot :manage, ContainerType
          cannot :manage, Location
          cannot :manage, Organization
     else
          cannot :read, :all
    end
    
   ActiveAdmin::ResourceController.class_eval do
    protected
  
      def current_ability
        @current_ability ||= AdminAbility.new(current_user)
      end
    end
end 
end