.PHONY: clean
clean:
	echo "Cleaning..."
	rm -f *.zip

.PHONY: lint
lint:
	echo "Linting..."
	cd terraform && terraform fmt

.PHONY: init
init:
	echo "Initiating..."
	cd terraform && terraform init

.PHONY: validate
validate:
	echo "Validating..."
	cd terraform && terraform validate

.PHONY: plan
plan:
	echo "Planning..."
	cd terraform && terraform plan

.PHONY: apply
apply:
	echo "Deploying..."
	cd terraform && yes yes | terraform apply
