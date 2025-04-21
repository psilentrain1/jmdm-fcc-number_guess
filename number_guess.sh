#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"

RANDOM_NUMBER=$((RANDOM % 1000 + 1))
GUESS_NO=1

LOGIN(){
  echo "Enter your username:"
  read -n 22 USERNAME

  USER=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USERNAME';")
  if [[ -z $USER ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    ADD_USER
  else
    DATA=$($PSQL "SELECT user_name, games_played, best_game FROM users WHERE user_id = $USER;")
    echo "$DATA" | while read USER_NAME BAR GAMES_PLAYED BAR BEST_GAME
    do
      echo "Welcome back $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
      echo "Guess the secret number between 1 and 1000:"
      read CURRENT_GUESS
      GUESS_NO=$((GUESS_NO++))
      CHECK $CURRENT_GUESS
    done
  fi
}

ADD_USER(){
  USER_ADDED=$($PSQL "INSERT INTO users (user_name) VALUES ('$USERNAME');")
  echo "Guess the secret number between 1 and 1000:"
  read -n 4 CURRENT_GUESS
  GUESS_NO=$((GUESS_NO++))
  CHECK $CURRENT_GUESS
}

GUESS(){
  read -n 4 CURRENT_GUESS
  GUESS_NO=$((GUESS_NO++))
  CHECK $CURRENT_GUESS
}

CHECK(){
  if (( $1 ))
  then
    if [[ $((1)) -lt $RANDOM_NUMBER ]]
    then
      echo "$RANDOM_NUMBER"
      echo "It's higher than that, guess again:"
      read -n 4 CURRENT_GUESS
      GUESS_NO=$((GUESS_NO++))
      CHECK $CURRENT_GUESS
    elif [[ $((1)) -gt $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      read -n 4 CURRENT_GUESS
      GUESS_NO=$((GUESS_NO++))
      CHECK $CURRENT_GUESS
    elif [[ $((1)) -eq $RANDOM_NUMBER ]]
    then
      echo "You guessed it in $GUESS_NO tries. The secret number was $RANDOM_NUMBER. Nice job!"
      SAVE_PLAY
    fi
  else
    echo "That is not an integer, guess again:"
    read -n 4 CURRENT_GUESS
    GUESS_NO=$((GUESS_NO++))
    CHECK $CURRENT_GUESS

  fi
}

SAVE_PLAY(){
  PLAYS=$($PSQL "SELECT games_played, best_game FROM users WHERE user_name = '$USER';")
  echo "$PLAYS" | while read GAMES_PLAYED BAR BEST_GAME
  do
    GAMES_PLAYED=$((GAMES_PLAYED++))
    if [[ -z $BEST_GAME ]]
    then
      BEST_GAME=$GUESS_NO
    else
      if [[ $GUESS_NO -lt $BEST_GAME ]]
      then
        BEST_GAME=$GUESS_NO
      fi
    fi
    PLAY_SAVED=$($PSQL "UPDATE users SET games_played = $((GAMES_PLAYED)), best_game = $((BEST_GAME)) WHERE user_name = '$USER';")
  done
}

LOGIN