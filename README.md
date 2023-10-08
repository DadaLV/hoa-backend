# README

## Prerequisites

Before you begin, make sure you have the following software installed on your machine:

- Ruby (version 3.1.2)
- Rails (version 7.0.6)
- PostgreSQL (version 15.2)

## Installation and Launch

1. **Preparing**
Make sure that Ruby and Rails gems are installed on your machine. If not, you can install them using your package manager or RVM (Ruby Version Manager).

After that, install all other gems used in this project with:
bundle install

Next, start the PostgreSQL database on your localhost with the credentials set at `config/database.yml`.

2. **Start the Rails server:**

To start the server on your localhost, run:
rails server

3. **Stop the server:**

To stop the server on your localhost, press `Ctrl+C`.

4. **Set up the database and run migrations:**

To create the database, run:
rails db:create

To run migrations, execute:
rails db:migrate

5. **Run seeds:**

rails db:seed

6. **Running Tests:**

To run the test suite, use the following command:
rspec

You can also run specific test files by providing the path to the file:
rspec path/to/test/file_spec.rb

7. **Show Logs:**

Rails will automatically show all the logs on your terminal window as you interact with the application.

## Dependencies

* bootsnap
* byebug (~> 11.1, >= 11.1.3)
* debug
* dotenv-rails
* jbuilder
* pg (~> 1.1)
* puma (~> 5.0)
* rack-cors
* rails (~> 7.0.6)
* rspec-rails (~> 6.0.0)
* rswag
* rubocop-rails
* tzinfo-data

## Ruby Version

* ruby 3.1.2p20

## Bundler Version

* 2.4.13