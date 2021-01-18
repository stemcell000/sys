class User < ActiveRecord::Base
  
  attr_writer :login
  
  scope :is_in_charge_of, -> u_id {joins(:items_users).where(:items_users => {user_id: u_id})}
  scope :by_teams,  ->(team_id) { joins(:teams).where(teams: { id: team_id }) }
  
  has_many :vials
  has_many :options
  has_and_belongs_to_many :teams
  
  accepts_nested_attributes_for :vials, reject_if: :all_blank
  accepts_nested_attributes_for :options
  accepts_nested_attributes_for :teams
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,:rememberable
         :validatable

  def login
    @login || self.username || self.email
  end
  
  def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions.to_h).first
      end
  end
    
   def role?(r)
     role.include? r.to_s
   end
   
   def full_name
     "#{firstname} #{lastname}"
   end
   
   def generate_recap
    
    email = self.email
    team_name = self.teams.nil? ? '-' : self.teams.map{|t| t.name}.to_sentence
    location_name = self.location.nil? ? '-' : self.location.name
    tel1 = self.tel1.nil? ? '-' : self.tel1
    tel2 = self.tel1.nil? ? '-' : self.tel2
    
     block = " 
          <div class='col-lg-12 col-md-12 col-sm-12'>
            <div class='row'> <strong> <a href = 'mailto:#{self.email}'>#{self.full_name}</a> </strong> </div>
            <div class='row'><strong>Team : </strong> #{ team_name } </div>
            <div class='row'><strong>Location : </strong> #{ location_name } </div>
            <div class='row'><strong>Tel1. : </strong> #{ self.tel1 } </div>
            <div class='row'><strong>Tel2. : </strong> #{ self.tel2 } </div>"
      self.recap = block
      self.save!
  end
  
   def password_match?
     self.errors[:password] << I18n.t('errors.messages.blank') if password.blank?
     self.errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
     self.errors[:password_confirmation] << I18n.translate("errors.messages.confirmation", attribute: "password") if password != password_confirmation
     password == password_confirmation && !password.blank?
  end

  # new function to set the password without knowing the current 
  # password used in our confirmation controller. 
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore. 
  # Instead you should use `pending_any_confirmation`.  
  def only_if_unconfirmed
   pending_any_confirmation {yield}
   #unless_confirmed {yield}
  end
  
  def password_required?
  # Password is required if it is being set, but not for new records
    if !persisted? 
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def set_username
    self.username= (self.firstname[0]+self.lastname).downcase!
    self.save!
  end
  
  def humanize_name
    self.firstname=self.firstname.humanize
    self.lastname=self.lastname.humanize
    self.save!
  end
  
  def create_option
     if self.options.empty?
      self.options.create(:display_all=> false, :display_all_users=> false, :display_all_contracts=> false)
    end
  end
    
 
end
