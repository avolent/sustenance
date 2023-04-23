export AWS_REGION

run_plan: zip init plan

run_apply: init apply

run_destroy_plan: init destroy_plan

run_destroy_apply: init destroy_apply

# Local Commands
local: requirements
	pipenv shell

requirements:
	pipenv clean
	pipenv install

version:
	aws --version
	terraform --version

zip: lambda_dependencies
	rm -f application.zip; cd application; zip -r ../application.zip ./*
	rm -f lambda-layer.zip; cd lambda-layer; zip -r ../lambda-layer.zip ./*

lambda_dependencies:
	rm -f -R lambda-layer
	pipenv run pip freeze > requirements.txt
	pip install -r requirements.txt -t lambda-layer

# Terraform Commands
init:
	cd infrastructure/; terraform init -input=false; terraform validate; terraform fmt

plan:
	cd infrastructure/; terraform plan -var="commit_id=$(shell git rev-parse --short HEAD)" -var="commit_description=$(shell git log -1 --pretty=%B)" -var="aws_region=$(shell echo $$AWS_REGION)" -out=tfplan -input=false

apply:
	cd infrastructure/; terraform apply "tfplan"

destroy_plan:
	cd infrastructure/; terraform plan -destroy -var="commit_id=$(shell git rev-parse --short HEAD)" -var="commit_description=$(shell git log -1 --pretty=%B)" -var="aws_region=$(shell echo $$AWS_REGION)" -out=tfplan -input=false

destroy_apply:
	cd infrastructure/; terraform apply "tfplan" 