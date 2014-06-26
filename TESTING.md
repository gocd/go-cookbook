Cookbook TESTING doc
====================

Bundler
-------
A ruby environment with Bundler installed is a prerequisite for using
the testing harness shipped with this cookbook. At the time of this
writing, it works with Ruby 1.9.3 and Bundler 1.6.2. All programs
involved, with the exception of Vagrant, can be installed by cd'ing
into the parent directory of this cookbook and running "bundle install"

Rakefile
--------
The Rakefile ships with a number of tasks, each of which can be ran
individually, or in groups. Typing "rake" by itself will perform style
checks with Foodcritic and integration tests with Test Kitchen using
the Vagrant driver by default.

```
$ rake -T
rake integration:vagrant  # Run Test Kitchen with Vagrant
rake style                # Run all style checks
rake style:chef           # Lint Chef cookbooks
```

Style Testing
-------------
Chef style tests can be performed with Foodcritic by issuing either
```
bundle exec foodcritic
```
or
```
rake style:chef
```

Integration Testing
-------------------
Integration testing is performed by Test Kitchen. After a
successful converge, tests are uploaded and ran out of band of
Chef. Tests should be designed to ensure that a recipe has
accomplished its goal.

Integration Testing using Vagrant
---------------------------------
Integration tests using Vagrant can be performed with either
```
bundle exec kitchen test
```
or
```
rake integration:vagrant
```
