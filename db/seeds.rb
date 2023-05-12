# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
raise InvalidEnvironmentError if ENV['RAILS_ENV'] == 'production'

User.all.each(&:delete)
p 'Deleted all old users.'

Skipper.all.each(&:delete)
p 'Deleted all old skippers.'

require_relative 'seeds/users'
require_relative 'seeds/skippers'
require_relative 'seeds/reviews'
require_relative 'seeds/friendships'
