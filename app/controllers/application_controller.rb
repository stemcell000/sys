class ApplicationController < ActionController::Base
  #check_authorization :unless => :devise_controller?
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:set_locale]
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :current_collections
  
  include Pagy::Backend

  ActiveRecord::Base.connection.tables.each do |t|
   ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
  
  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end
  
  def configure_permitted_parameters
    added_attrs = [:username, :email, :encrypted_password, :firstname, :lastname, :location_id, :recap, :role, :password, :password_confirmation, :remember_me,
      {team_ids: []}, {position_ids: []}, teams_attributes:[:id, :name]]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
  def toggle_display
    @current_user = current_user
    @current_user.toggle(:display)
  end
      
   rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
  
  # path for redirection after user sign_in, depending on user role
  #def after_sign_in_path_for(user)
  # user.role == "superadmin"? admin_dashboard_path : root_path 
  #end
end

