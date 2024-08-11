#!/bin/bash

# Number guessing game

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
SECRET_NUMBER=$(( (RANDOM % 1000) + 1 ))
ATTEMP=0

echo "Test ramdom: $SECRET_NUMBER"