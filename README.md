Notepad v2.0
=

An educational console application Notepad that uses a SQLite database to store data. Supports the following types of notes: Memo, Task, Link.

Requirements
-

* Windows 10 x32/x64 or Ubuntu 20.04 LTS or macOS Big Sur
* Ruby 2.7.2  or higher

Installation Ruby
-

* Ubuntu
  <https://github.com/rbenv/rbenv#installing-ruby-versions>

* Windows
  <https://rubyinstaller.org/downloads/>

* macOS
  <https://github.com/rbenv/rbenv#installing-ruby-versions>

Quick start
-

### Attention

For correctly application work, you need install a Ruby gem 'sqlite3' (<https://github.com/sparklemotion/sqlite3-ruby>).
For gem installation, on command line/terminal, go to the directory, where you unpacked the archive and type in the
following commands:

```ruby
bundle install
```

You also need to create a SQLite database named 'notepad.sqlite' and then create a 'posts' table with the following fields:

```ruby
type:text
created_at:numeric
text:text
url:text
due_date:text
```

To work with SQLite databases, you can use 'SQLiteStudio' (<https://github.com/pawelsalawa/sqlitestudio>)

Instructions how to use
-

To create a record, in command line/terminal, go to the directory, where you unpacked the archive and type in the
following command:

```ruby
ruby write_to_db.rb
```

To read all record, in command line/terminal, go to the directory, where you unpacked the archive and type in the
following command:

```ruby
ruby read_from_db.rb
```

Command with key `-h` will show additional startup options:

```ruby
ruby read_from_db.rb -h

--type POST_TYPE (example: ruby read_from_db.rb --type Link)
--id POST_ID (example: ruby read_from_db.rb --id 6)
--limit NUMBER (example: ruby read_from_db.rb --limit 3)
```
