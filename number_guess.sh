#!/bin/bash

# Number guessing game

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
SECRET_NUMBER=$(( (RANDOM % 1000) + 1 ))
ATTEMP=0

MAIN(){
  echo "Enter your username:"
  read USERNAME

  # search username in db
  USER_ID=$($PSQL "SELECT * FROM users WHERE name='$USERNAME'")

  # if don't exits
  if [[ -z $USER_ID ]]
  then
    USER_INSERT_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    # if the username exists
    USER_DATA=$($PSQL "SELECT games_played, MIN(attemps) FROM users INNER JOIN games ON users.user_id=games.user_id WHERE name='$USERNAME' GROUP BY users.games_played")

    echo $USER_DATA | while read GAMES_PLAYED BAR BEST_GAME
    do     
        echo "Welcome back, $(echo $USERNAME | sed -r 's/^ *| *$//g')! You have played $(echo $GAMES_PLAYED | sed -r 's/^ *| *$//g') games, and your best game took $(echo $BEST_GAME | sed -r 's/^ *| *$//g') guesses."
    done
  fi

  echo "Guess the secret number between 1 and 1000:"

  # GUESS
}

MAIN