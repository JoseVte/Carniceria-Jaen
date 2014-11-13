# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141108135729) do

  create_table "carritos", force: true do |t|
    t.integer "usuarios_id"
  end

  create_table "carritos_productos", id: false, force: true do |t|
    t.integer "carrito_id"
    t.integer "producto_id"
  end

  create_table "productos", force: true do |t|
    t.string  "nombre",                                                   null: false
    t.text    "descripcion"
    t.float   "precioKg",                                                 null: false
    t.integer "stock",        default: 0
    t.boolean "ofertas",      default: false
    t.float   "rebaja",       default: 0.0
    t.integer "proovedor_id"
    t.string  "url_imagen",   default: "/assets/images/missing_prod.png"
  end

  create_table "proovedors", force: true do |t|
    t.string "nombreEmpresa",                                             null: false
    t.string "nombre"
    t.string "apellidos"
    t.string "email",                                                     null: false
    t.text   "direccion",                                                 null: false
    t.string "telefono",                                                  null: false
    t.string "url_imagen",    default: "/assets/images/missing_prod.png"
  end

  create_table "usuarios", force: true do |t|
    t.string "user",                                                        null: false
    t.string "password_digest",                                             null: false
    t.string "nombre",                                                      null: false
    t.string "apellidos",                                                   null: false
    t.string "email",                                                       null: false
    t.text   "direccion",                                                   null: false
    t.string "telefono",                                                    null: false
    t.string "url_imagen",      default: "/assets/images/missing_user.png"
  end

end
