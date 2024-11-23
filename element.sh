#!/bin/bash
# Agrego queryDB
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
# if $1 is a nbr get ATOM_NBR direct else undirect
        if [[ $1 =~ ^[0-9]+$ ]]
        then
                ATOM_NBR=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")

        else
                ATOM_NBR=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
        fi

# if element exist (not empty ATOM_NMR)
if [[ ! -z $ATOM_NBR ]]
then
        VARS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOM_NBR")
                # get each var, format to print & print result+
        echo "$VARS" | while IFS="|" read -r an name symbol type mass mp bp
        do
        # Imprimir el resultado formateado
        echo -e "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
        done

else
        echo I could not find that element in the database.
fi
else
        echo Please provide an element as an argument.
fi