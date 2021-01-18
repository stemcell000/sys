# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

types = ContainerType.create([{name: 'row organization'}, {name: 'column organization'}])
box_types = BoxType.create([{name: '9x9', vertical_max: 9, horizontal_max: 9}, {name: '12x8', vertical_max: 8, horizontal_max: 12}])