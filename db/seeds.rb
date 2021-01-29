# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

types = ContainerType.create([{name: 'row organization'}, {name: 'column organization'}])
box_types = BoxType.create([{name: '9x9', vertical_max: 9, horizontal_max: 9}, {name: '12x8', vertical_max: 8, horizontal_max: 12}])
colors = Color.create([{name: 'Blue', code: '#0275d8'},
	{name: 'Green', code: '##5cb85c'},
	{name: 'Yellow', code: '#f0ad4e'},
	{name: 'Red', code: '#d9534f'},
	{name: 'White', code: '#f7f7f7'},
	{name: 'White', code: '#C0C0C0'}]
	)
