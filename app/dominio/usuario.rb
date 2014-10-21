require 'active_record'

#Clase principal de usuarios
class Usuario < ActiveRecord::Base
  validates :user, uniqueness: true
  validates :email, uniqueness: true
end