#!/bin/bash


gcloud container clusters get-credentials $(cat ./variables.tf  | grep -iA4 prefix | grep -i default | awk -F= '{print $2}' | tr -d '"')-cluster --region $(cat ./variables.tf  | grep -iA4 region | grep -i default | awk -F= '{print $2}' | tr -d '"')
