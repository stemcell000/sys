class AddSuperadmin < ActiveRecord::Migration[5.0]
  def up  
          team = Team.new
          team.name = 'Local'
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
          u.save!(validate: false)
          u.teams << team
  end
  
  def down
  end
end

