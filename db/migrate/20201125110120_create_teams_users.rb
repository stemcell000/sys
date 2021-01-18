class CreateTeamsUsers < ActiveRecord::Migration
 def self.up
        create_table :teams_users do |t|
           t.belongs_to :team, index: true
           t.belongs_to :user, index: true
           t.timestamps
        end
      end
 
      def self.down
        drop_table :teams_users
      end
end
