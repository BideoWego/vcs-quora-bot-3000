# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

REAL_KEY = '1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc'
SANDBOX_KEY = '1cObJm4eFx1oYjMRzgNsgEymoQa6J0oWBUVW2yIRcpVo'
SPREADSHEET_KEY = SANDBOX_KEY

if Rails.env == 'development'
  puts 'Migrating and reseting database'
  Rake::Task['db:migrate:reset'].invoke
else
end

puts 'Creating Spreadsheets'
Spreadsheet.create(
  :key => SPREADSHEET_KEY
)

puts 'Creating Scrapes'
5.times do
  scrape = Scrape.create(
    :data => {:foo => 'bar'},
    :spreadsheet_id => Spreadsheet.first.id
  )
end

puts 'done!'