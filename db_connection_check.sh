#!/bin/bash

DB_HOST=""
DB_PORT=""
DB_NAME=""
DB_USER=""
DB_PASSWORD=""
SERVER=""

EMAIL_RECIPIENT=""

# Connection check
PG_CONNECTION=$(PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -w -t -c "SELECT 1" 2>&1)

if [[ "$PG_CONNECTION" =~ "could not connect" ]]; then
  echo "Cannot connect to the database $DB_HOST:$DB_PORT" | mail -s "Cannot connect to the database $DB_HOST:$DB_PORT from $SERVER:" "$EMAIL_RECIPIENT"
fi