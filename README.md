CSV Query - Use SQL to query CSV data
=====================================

CSV Query is a command line tool that allows you to run SQL queries on data
stored in CSV files.

For example:

    $ csvq --select "count(*)" sample.csv
    count(*)
    --------
           1

Assumptions
-----------

The first row of data is assumed to be headers.

All fields are created as `VARCHAR(255)`, which hopefully works for most cases.

Behind the scenes
-----------------

CSV Query loads the CSV data into an in-memory SQLite database. Thus, the SQL
queries need to be SQLite-flavored where applicable.

Alternative/related projects
----------------------------

* [csvq.py - Python variant that does almost the same thing](http://www.gl1tch.com/~lukewarm/software/csvq/)
* [CSVql - A query language for CSV files](https://github.com/ondrasej/CSVql)

License
-------

Licensed under the MIT License. See LICENSE for details.