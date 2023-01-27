echo:
	echo "Printing..."

lint:
	echo "Linting..."
	cd infrastructure && terraform fmt

start:
	npm start

test:
	npm test

build:
	npm run build:lambda

package:
	echo "Packaging..."
	npm run package:lambda
	cp ./src/lambda.zip ./infrastructure/lambda.zip

init:
	echo "Initiating..."
	cd infrastructure && terraform init

validate:
	echo "Validating..."
	cd infrastructure && terraform validate

plan:
	echo "Planning..."
	cd infrastructure && terraform plan

deploy:
	echo "Deploying..."
	cd infrastructure && terraform apply
