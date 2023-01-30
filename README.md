# :zap: Echo Web API JavaScript

![GitHub repo size](https://img.shields.io/github/repo-size/raymondsquared/echo-web-api-javascript?style=plastic)
![GitHub pull requests](https://img.shields.io/github/issues-pr/raymondsquared/echo-web-api-javascript?style=plastic)
![GitHub Repo stars](https://img.shields.io/github/stars/raymondsquared/echo-web-api-javascript?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/raymondsquared/echo-web-api-javascript?style=plastic)

## :page_facing_up: Table of contents

- [:zap: Echo Web API JavaScript](#zap-echo-web-api-javascript)
  - [:page_facing_up: Table of contents](#page_facing_up-table-of-contents)
  - [:books: General info](#books-general-info)
  - [:camera: Screenshots](#camera-screenshots)
  - [:signal_strength: Technologies](#signal_strength-technologies)
  - [:floppy_disk: Setup](#floppy_disk-setup)
  - [:wrench: Testing](#wrench-testing)
  - [:computer: Code Examples](#computer-code-examples)
  - [:cool: Features](#cool-features)
  - [:clipboard: Status, Testing & To-Do List](#clipboard-status-testing--to-do-list)
  - [:clap: Inspiration](#clap-inspiration)
  - [:file_folder: License](#file_folder-license)
  - [:envelope: Contact](#envelope-contact)

## :books: General info

- Simple web API to echo back your CRUD operations

## :camera: Screenshots

- TBA

## :signal_strength: Technologies

- Node.js v16
- AWS
- Lambda
- Terraform

## :floppy_disk: Setup

- Install Node.js dependencies

  ```javascript
  npm install
  ```

- Install Terraform

  ```bash
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  
  make infastructure__init
  ```

## :wrench: Testing

```javascript
make app__test
```

## :computer: Code Examples

- Validate:

  ```bash
  make app__lint
  make infrastructure__lint
  make infrastructure__validate
  ```

- Application:

  ```bash
  make app__build
  make app__package
  make app__publish
  ```

- Infrastructure:

  ```bash
  make infrastructure__plan
  make infrastructure__apply
  ```

## :cool: Features

- TBA

## :clipboard: Status, Testing & To-Do List

- Status: Working

- To-Do:
  - Application:
    - Create DynamoDB client in a separate class
  - Infrastructure:
    - Move API key to API Gateway

## :clap: Inspiration

- [3musketeers](https://3musketeers.io/)

## :file_folder: License

- MIT

## :envelope: Contact

- Repo created by [Raymond](https://github.com/raymondsquared)
