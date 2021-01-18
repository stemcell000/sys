class AddSuperadmin < ActiveRecord::Migration
  def up    
          u = User.new
          u.email     = 'marc.lechuga@inserm.fr'
          u.username = 'mlechuga'
          u.firstname = 'Marc'
          u.lastname = 'Lechuga'
          u.encrypted_password   = 'stemcell'
          u.password = 'stemcell'
          u.password_confirmation = 'stemcell'
          u.role = 'superadmin'
          u.save!(validate: false)
          u.options.create(display_all: false)
          t = Team.new(name: "Admin", acronym: "ADM")
          u.save!(validate: false)
          u.teams << t
  end
  
  def down
  end
end

