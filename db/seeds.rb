# frozen_string_literal: true

Category.destroy_all

categories = [
  { name: 'Construction' },
  { name: 'Entertainment' },
  { name: 'Technic' },
  { name: 'Games' },
  { name: 'Services' },
  { name: 'Clothes' }
]

categories.each do |category|
  Category.create! category
end
