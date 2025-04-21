#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"

RANDOM_NUMBER=$((RANDOM % 1000 + 1))

LOGIN(){
  echo "Enter your username:"
  read -n 22 USERNAME

  USER=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USERNAME';")
  if [[ -z $USER ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    # ADD_USER
    # GUESS
  else
    DATA=$($PSQL "SELECT user_name, games_played, best_game FROM users WHERE user_id = $USER;")
    echo "$DATA" | while read USER_NAME BAR GAMES_PLAYED BAR BEST_GAME
    do
      echo "Welcome back $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
      # GUESS 
    done
  fi
}

# ADD_USER(){}

# GUESS(){}

LOGIN