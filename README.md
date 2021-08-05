Notepad v2.1
=

An educational console application Notepad that uses a SQLite database to store data. Supports the following types
of notes: Memo, Task, Link.

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

Before run  the app, on command line/terminal, go to the directory, where you clone repository and type in the
following command:

```ruby
bundle
```

Instructions how to use
-

To create a record, in command line/terminal, go to the directory, where you unpacked the archive and type in the
following command:

```ruby
bundle exec ruby write_to_db.rb
```

To read all record, in command line/terminal, go to the directory, where you unpacked the archive and type in the
following command:

```ruby
bundle exec ruby read_from_db.rb
```

Command with key `-h` will show additional startup options:

```ruby
bundle exec ruby read_from_db.rb -h

--type POST_TYPE (example: ruby read_from_db.rb --type Link)
--id POST_ID (example: ruby read_from_db.rb --id 6)
--limit NUMBER (example: ruby read_from_db.rb --limit 3)
```
