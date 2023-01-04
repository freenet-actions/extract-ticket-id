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
* you will have to set the variables needed by `extract_ticket_id.sh` which are
  `INPUT_GITHUB`, `INPUT_REGEX` and `GITHUB_OUTPUT`
* `GITHUB_OUTPUT` must be set with the name of an existing file
* `INPUT_GITHUB` must be filled with the json of a GitHub event.
  If you have a file containing the event json, export it to a variable with
  ```
  INPUT_GITHUB=$(cat test_event.json)
  ```
* `INPUT_REGEX` must be set with some regex (see above)
* run the image
  ```
  docker run -e INPUT_GITHUB="$INPUT_GITHUB" -e INPUT_REGEX="$INPUT_REGEX" -e GITHUB_OUTPUT="$GITHUB_OUTPUT" extract-ticket-id
  ```
  
If you have bash and jq installed on your machine you can even
test the script directly without using docker:
```shell
INPUT_GITHUB=$INPUT_GITHUB INPUT_REGEX="$INPUT_REGEX" GITHUB_OUTPUT=/tmp/github_output ./extract_ticket_id.sh
```
The output will then be in file `/tmp/github_output` which has to be created first.