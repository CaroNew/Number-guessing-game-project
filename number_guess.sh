#!/bin/bash

# Number guessing game

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
SECRET_NUMBER=$(( (RANDOM % 10) + 1 ))
ATTEMP=0

MAIN(){
  echo "Enter your username:"
  read USERNAME

  # search username in db
  USER_DATA=$($PSQL "SELECT games_played, MIN(attemps) FROM users INNER JOIN games ON users.user_id=games.user_id WHERE name='$USERNAME' GROUP BY users.games_played")

  # if don't exits
  if [[ -z $USER_DATA ]]
  then
    USER_INSERT_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    # if the username exists
    # USER_DATA=$($PSQL "SELECT games_played, MIN(attemps) FROM users INNER JOIN games ON users.user_id=games.user_id WHERE name='$USERNAME' GROUP BY users.games_played")

    echo $USER_DATA | while IFS="|" read GAMES_PLAYED BEST_GAME
    do     
        echo -e "\nWelcome back, $(echo $USERNAME | sed -r 's/^ *| *$//g')! You have played $(echo $GAMES_PLAYED | sed -r 's/^ *| *$//g') games, and your best game took $(echo $BEST_GAME | sed -r 's/^ *| *$//g') guesses."
    done
  fi

  echo "Guess the secret number between 1 and 1000:"

  GUESS
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
  # save number of times played y number of attempts
  INSERT_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID")
  INSERT_ATTEMPS=$($PSQL "INSERT INTO games(user_id, attemps) VALUES($USER_ID, $ATTEMP)")

  # echo "You guessed it in $ATTEMP tries. The secret number was $SECRET_NUMBER. Nice job!"

}

GUESS(){
  read USER_NUMBER

  if [[ ! $USER_NUMBER =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    GUESS
  else  
    ((ATTEMP++))

    if [[ $USER_NUMBER -gt $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      GUESS
    elif [[ $USER_NUMBER -lt $SECRET_NUMBER ]]
    then 
      echo "It's higher than that, guess again:"  
      GUESS
    else
       echo "You guessed it in $ATTEMP tries. The secret number was $SECRET_NUMBER. Nice job!"
    fi
  fi
}   

MAIN