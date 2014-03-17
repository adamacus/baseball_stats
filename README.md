# Baseball Statistics Code Sample

This coding example calculates some baseball statistics.  It loads statistics from a csv into
a database that it uses for querying.

## Installation

* Clone the project
* Install gems and set up the db

        bundle install
        bundle exec rake db:setup

## Usage
* Run the statistics

        bundle exec rake baseball:stats

## Tests
* Prepare test schema

        bundle exec rake db:test:prepare

* Run the tests
        bundle exec rake spec
