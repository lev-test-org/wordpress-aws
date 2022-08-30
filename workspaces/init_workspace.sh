#!/bin/bash
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi
if [ $# -gt 2 ]; then
    echo "too many arguments"
    exit 1
fi
workspace_name="$1"
TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r .credentials.\"app.terraform.io\".token)
cat <<EOPF > payload.json
{
  "data": {
    "attributes": {
      "name": "${workspace_name}"
    },
    "type": "workspaces"
  }
}
EOPF
response=$(curl --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/vnd.api+json" --request POST  --data @payload.json  https://app.terraform.io/api/v2/organizations/TeraSky/workspaces)
workspace_id=$(echo ${response} | jq .data.id)
cat <<EOBF > backend_file.hcl
hostname = "app.terraform.io"
organization = "TeraSky"
workspaces { name = "${workspace_name}" }
EOBF

cat <<EOVF > var_payload.json
{
  "data": {
    "type":"vars",
    "attributes": {
      "key":"TFE_TOKEN",
      "value":"${TOKEN}",
      "description":"tfe token to manipulate states",
      "category":"env",
      "hcl":false,
      "sensitive":true
    },
    "relationships": {
      "workspace": {
        "data": {
          "id":${workspace_id},
          "type":"workspaces"
        }
      }
    }
  }
}
EOVF
curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @var_payload.json \
  https://app.terraform.io/api/v2/vars

rm var_payload.json

