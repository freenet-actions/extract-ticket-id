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
  # TICKETID may be a multiline string.
  # For the output newline characters are not relevant and can be replaced
  message=$(echo $TICKETID | tr '\n' ' ')
  echo "Extracted ticket ids: $message"
  echo "ticket_id=$message" >> $GITHUB_OUTPUT
fi

