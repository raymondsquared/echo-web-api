.PHONY: clean
clean:
	echo "Cleaning..."
	npm run clean

.PHONY: lint
lint:
	echo "Linting..."
	npm run lint

.PHONY: start
start:
	npm start

.PHONY: test
test:
	npm test

.PHONY: build
build:
	echo "Building..."
	mkdir -p dist
	mkdir -p dist/layers
	mkdir -p dist/lambdas
	npm run build:layers
	npm run build:lambdas

.PHONY: package
package:
	echo "Packaging..."
	npm run package:layers
	npm run package:lambdas

.PHONY: publish
publish:
	echo "Publishing..."
	cp dist/layers/**/*.zip ../infrastructure/
	cp dist/lambdas/**/*.zip ../infrastructure/
