class DatabaseLabBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection DATABASE_LAB
end