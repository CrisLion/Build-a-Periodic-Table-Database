#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  if [[ $1 =~ ^[1-9]+$ ]]
  then
    QUERY_ELEMENT_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")
  else
    QUERY_ELEMENT_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1';")
  fi

  if [[ -z $QUERY_ELEMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $QUERY_ELEMENT_RESULT | while IFS=" | " read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
  fi
fi

