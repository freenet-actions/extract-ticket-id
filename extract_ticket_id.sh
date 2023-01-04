#!/bin/bash

GITHUB_CONTEXT=$INPUT_GITHUB
REGEX=$INPUT_REGEX

# extract the commit message from field event.head_commit.message
MESSAGE=$(jq -r '.event.head_commit.message' <<< $GITHUB_CONTEXT)
echo "Extracting from message: $MESSAGE"

echo "Using regular expression to extract: $REGEX"
TICKETID=$(sed -nE "s/$REGEX/\1/p" <<< "$MESSAGE")

if [ -z "$TICKETID" ]
then
  echo "No ticket id found in message"
else  
  # TICKETID may be a multiline string. Convert to one line first
  message=$(echo $TICKETID | tr '\n' ' ')
  # Split the string by space
  readarray -d " " -t items <<< "$message"
  # only use the first item
  message=${items[0]}
  echo "Extracted ticket id: '$message'"
  echo "ticket_id=$message" >> $GITHUB_OUTPUT
fi

