module UsersHelper
def num_to_phone(num)
  "#{ num[0..1] } #{ num[2..3] } #{ num[4..5] } #{ num[6..7] } #{ num[8..9] }"
end

def role_set(name)
  case name
   when "administrator"
     t("roles.administrator")
   when "user"
     t("roles.user")
    when "guest"
     t("roles.guest")
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
              ["user" , t("roles.user")],
              ["guest" , t("roles.guest")]]
        elsif user.role =="administrator" || user.role == "HR_administrator"
          roles_list = [["administrator", t("roles.administrator")],
              ["user" , t("roles.user")],
              ["guest" , t("roles.guest")]]
        elsif can? :update, user
          roles_list = [["user" , t("roles.user")],
              ["guest" , t("roles.guest")]]
        end
        return roles_list
 end
end