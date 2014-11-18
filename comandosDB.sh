#!/bin/bash

DB_DEV=db/cf_development.sqlite3
DB_TEST=db/cf_test.sqlite3
DB_SCHEMA=db/schema.rb

if [ -e "$DB_DEV" ]; then
  echo 'Borrando base de datos de desarrollo'
  rm $DB_DEV
fi

if [ -e "$DB_TEST" ]; then
  echo 'Borrando base de datos de test'
  rm $DB_TEST
fi

if [ -e "$DB_SCHEMA" ]; then
  echo 'Borrando schema de la base de datos'
  rm $DB_SCHEMA
fi

bundle exec rake db:migrate
bundle exec rake db:migrate RACK_ENV=test

bundle exec rake db:fixtures:load RACK_ENV=development
bundle exec rake db:fixtures:load RACK_ENV=test

echo 'Recreacion de la base de datos completada'