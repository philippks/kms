![KMS logo](app/assets/images/logo-blue.png)


![GitHub release](https://img.shields.io/github/release/philippks/kms.svg) [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build Status](https://travis-ci.com/philippks/kms.svg?token=A6pZ6ecyzEpUNRjpj3Sq&branch=master)](https://travis-ci.com/philippks/kms)

Web application for time tracking and invoicing.

Initially created for the [Koster Consulting AG](http://kosterconsulting.ch/) and since multiple years in productive use.


## Features
* Time & absences tracking
* Time & invoice reports
* Generate invoices based on tracked time
* Send invoice by e-mail
* Manage invoice payments
* and many more...

## Demo

Only available in German for now:

* Username: demo@user.ch
* Passwort: demopassword
* URL: [here](https://kms-demo.kdev.ch)



## Getting Started

### Prerequisites

* ruby 2.5
* bundler
* yarn
* Libreoffice (will be removed)
* PostgreSQL

### Install Dependencies
```bash
bundle
yarn install
```

### Configuration
Basic configuration in `.env` file:
```
POSTGRES_HOST=localhost
POSTGRES_USER=postgres
POSTGRES_DATABASE="kms"
POSTGRES_PASSWORD=password
SECRET_KEY_BASE=xxx
```

### Start Locally
```bash
bundle exec rails s
```
Access web application: http://localhost:3000

### Run Tests
```bash
bundle exec rspec
```

## Hints

### Invoice Configuration

The invoice parameters are configured with env variables:

* INVOICE_IBAN
* INVOICE_VAT_NUMBER
* INVOICE_SWIFT
* INVOICE_MAIL_FOOTER (use \n for newlines)

To use a company template for the invoices, set the path to the corresponding PDF as `INVOICE_COMPANY_TEMPLATE_PATH`, e.g.
``` yml
INVOICE_COMPANY_TEMPLATE_PATH='/home/kms/invoice_template.pdf'
```

### Master Password
To set a master password which can login as each user, generate an encrypted password inside the rails console
``` ruby
Employee.new(password: 'mymasterpassword').encrypted_password
```

And save this value inside the `.env` file as `ENCRYPTED_MASTER_PASSWORD`, e.g.
``` yml
ENCRYPTED_MASTER_PASSWORD='$2a$11$pwpCKdGI0fu7I1ISy19Uz.UCiVgJ03c/XN2nIylI952Qdvmbh89cu'
```

## Questions?

For any questions drop me a mail: <kms-opensource@use.startmail.com>

## License

[GPL-3.0](https://github.com/philippks/kms/blob/master/LICENSE)
