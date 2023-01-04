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
  echo "Extracted ticket id: $TICKETID"
  echo "ticket_id=$TICKETID" >> $GITHUB_OUTPUT
fi

