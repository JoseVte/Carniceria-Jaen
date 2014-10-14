require 'active_record'

#Clase principal de usuarios
class Usuario < ActiveRecord::Base
  validates :email, uniqueness: true
end