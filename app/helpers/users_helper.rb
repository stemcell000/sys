module UsersHelper
def num_to_phone(num)
  "#{ num[0..1] } #{ num[2..3] } #{ num[4..5] } #{ num[6..7] } #{ num[8..9] }"
end

def invcolor(obj)
    if obj.active_status == false
      "danger"
    end
  end

def role_set(name)
  case name
   when "superadmin"
     t("roles.superadmin")
   when "administrator"
     t("roles.administrator")
   when "HR_administrator"
     t("roles.hr_administrator")
   when "inventory_manager"
     t("roles.inventory_manager")
   when "team_leader"
     t("roles.team_leader")
   when "user"
     t("roles.user")
   else
     t("role.unknown")
  end
  end
 
 def display_label_set
     if can? :manage, :User
       mylabel = t("users.display_all_users")
     else
       mylabel = "Display my team(s) only"
     end
   return mylabel
 end
 
  def set_roles_list(user)
    
       if user.role == "superadmin"
             roles_list = [["superadmin", t("roles.superadmin")],
              ["administrator", t("roles.administrator")],
              ["HR_administrator", t("roles.hr_administrator")],
              ["inventory_manager", t("roles.inventory_manager")],
              ["team_leader" , t("roles.team_leader")],
              ["user" , t("roles.user")]]
        elsif user.role =="administrator" || user.role == "HR_administrator"
          roles_list = [["team_leader" , t("roles.team_leader")],
              ["user" , t("roles.user")]]
        elsif can? :update, user
          roles_list = [["inventory_manager", t("roles.inventory_manager")],
              ["team_leader" , t("roles.team_leader")]]
        end
        return roles_list
 end
end