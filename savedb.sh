#!/bin/bash
eval "pg_dump -cC --inserts -U freecodecamp number_guess > number_guess.sql"