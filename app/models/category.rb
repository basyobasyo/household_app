class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '-' },
    { id: 2, name: '食費' },
    { id: 3, name: '交通費' }
  ]

  include ActiveHash::Associations
  has_many :payments
end
