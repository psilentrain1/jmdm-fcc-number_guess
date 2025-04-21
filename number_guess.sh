#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$((RANDOM % 1000 + 1))

LOGIN(){
  echo "Enter your username:"
  read -n 22 USERNAME

  USER=$($PSQL "SELECT user_id FROM users WHERE user_name = $USERNAME;")
  if [[ -z $USER ]]
  then
    echo "User not exist"
  else
    echo "User exist"
  fi
}

# GUESS(){}

LOGIN