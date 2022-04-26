# Introduction

Extracts ticket ids from a github event.
Currently it extracts it from the head_commit.message.

# Inputs

* github: the json of the github event. E.g. from `${{ toJson(github) }}`
* regex: a regular expression which will be used in a sed command.
  The expression must define a capturing group for the ticket id.  
  For JIRA the following works:
  ```
  ^.*((AAA|BBB)-[0-9]{4,}).*$
  ```
  where `AAA` and `BBB` are JIRA projects.

# Outputs

* ticket_id: the result of the extraction. May be unset if no ticket id was found

# Example

```
      - id: extract_ticket_id
        uses: freenet-actions/extract-ticket-id@v1
        with:
          github: ${{ toJson(github) }}
          regex: "^.*((OMS|IAT)-[0-9]{4,}).*$"
```

# How to develop this action without using a github runner

* build the docker image with
  ```
  docker build -t extract-ticket-id .
  ```
* export the json in some way to an environment variable, e.g.
  `GITHUB_CONTEXT`.
  If you have a file containing the event json, export it to a variable with
  ```
  GITHUB_CONTEXT=$(cat test_event.json)
  ```
* run the image
  ```
  docker run -e INPUT_GITHUB="$GITHUB_CONTEXT" extract-ticket-id
  ```
  
If you have bash and jq installed on your machine you can even
test the script directly without using docker:
```shell
INPUT_GITHUB=$GITHUB_CONTEXT ./extract_ticket_id.sh
```
or
```
INPUT_GITHUB=$(cat test_event.json) ./extract_ticket_id.sh
```