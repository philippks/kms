![KMS logo](app/assets/images/logo-blue.png)


![GitHub release](https://img.shields.io/github/release/philippks/kms.svg) [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build Status](https://travis-ci.org/philippks/kms.svg?branch=master)](https://travis-ci.org/philippks/kms)

A web application for time tracking and invoicing.

Initially created for the [Koster Consulting AG](http://kosterconsulting.ch/) and in productive use since multiple years.


## Features
* Time & absences tracking
* Time & invoice reports
* Generate invoices based on tracked time
* Send invoice by e-mail
* Manage invoice payments
* and many more...


## Getting Started

Use docker for development, testing and production.

### Start Locally
Build containers:
```
docker-compose build
```

Copy and edit configuration file:
```
cp .env.example .env
```

Start app for development:
```
docker-compose up development
```

Access web application: http://localhost:3000

### Run Production

Change values in `.env` accordingly.

Start server with:
```
docker-compose up production
```

Access web application: http://localhost:3000

### Run Tests

Run tests inside docker container with:
```
docker-compose run --rm test
```

### Configuration

See `.env.example` for example configuration.

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

## Questions?

For any questions drop me a mail: <kms-opensource@use.startmail.com>

## License

[GPL-3.0](https://github.com/philippks/kms/blob/master/LICENSE)
