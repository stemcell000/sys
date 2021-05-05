class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :edit_hr, :update, :destroy, :editadmin, :show]
  before_action :set_option, only: [:index]
  before_action :set_roles, only: [:edit, :edit_hr]
   
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def index
    @departments = Department.all.order(name: "asc").uniq.map{ |obj| [obj['name'], obj['id']]}
    @teams = Team.where.not(name: 'All').order(name: "asc").uniq.map{ |obj| [obj['name'], obj['id']] }
    @q = User.ransack(params[:q])
    
    records = @q.result(distinct: true).includes(:teams)
    records = records.where.not(role: 'superadmin')

    #Config de l'affichage des résultats.
    @pagy, @users = pagy(records.order(:id), users: 30)
  end
 
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create(user_params)
    if @user.valid?
      render :action => :show
      flash.keep[:success] = "A new user has been successfully created!"
      #
      set_adds(@user)
      #
      if ['superadmin', 'administrator'].include? @user.role
        @user.teams.destroy_all
        Team.all.each do |team|
          @user.teams << team
         end
      end
      @user.generate_recap
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  
  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    @user.update_attributes(user_params)
    if @user.valid?
      flash.keep[:success] = "Profile udpated."
      if ['superadmin', 'administrator'].include? @user.role
        @user.teams.destroy_all
        Team.all.each do |team|
          @user.teams << team
        end
        set_adds(@user)
      end
      @user.generate_recap
      redirect_to user_path
    else
      render :action => :edit
    end
  end
  
  def show
    
  end
  
 def destroy
   @user.role = 'former_employee'
   #
   if @user.items.exists
     @user.items.each do |item|
       item.generate_recap
     end
   end
   #
   @user.items.delete
 end
    
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
 def user_params
    params.require(:user).permit(:username, :email, :firstname, :lastname, :role, :login, :password, :password_confirmation,
    :start_date, :end_date,
    team_ids: [], teams_attributes: [:id, :name],
    options_attributes: [:display_all])
 end
 
 def set_option
    @option = current_user.options.first
 end
 
 def set_adds(user)
   user.generate_recap
   user.set_username
   user.humanize_name
   user.create_option
 end
 
 def set_roles
     @roles_list = [["superadmin", "superadmin"],
      ["administrator", "administrator"],
      ["user" , "user"], ["guest" , "guest"]]
 end
 
end
