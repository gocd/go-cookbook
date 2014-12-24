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
rake integration:cloud    # Run Test Kitchen cloud plugins
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

Integration Testing using Cloud providers
-----------------------------------------
Integration tests can be performed on cloud providers using Test Kitchen plugins. This cookbook ships a .kitchen.cloud.yml that references environmental variables present in the shell that kitchen test is ran from. These usually contain authentication tokens for driving IaaS APIs, as well as the paths to ssh private keys needed for Test Kitchen log into them after they've been created.

Examples of environment variables being set in ~/.bash_profile:

```
# digitalocean (APIv1)
export DIGITALOCEAN_API_KEY='your_bits_here'
export DIGITALOCEAN_CLIENT_ID='your_bits_here'
export DIGITALOCEAN_SSH_KEY_IDS='your_bits_here'    #CSV String of IDs
export DIGITALOCEAN_SSH_KEY_PATH='your_bits_here'

#ec2
export AWS_ACCESS_KEY='your_bits_here'
export AWS_SECRET_KEY='your_bits_here'
export AWS_SECURITY_GROUP='your_bits_here'
export AWS_SSH_KEY_ID='your_bits_here'
export AWS_SSH_KEY_PATH='your_bits_here'
```

**Note:** There is currently a bug in kitchen-digitalocean (0.8.2) which forces DIGITALOCEAN_SSH_KEY_IDS to require at least two entires. It is prefectly fine however to use the same key id twice.

Integration tests using cloud drivers can be performed with either
```
export KITCHEN_YAML=.kitchen.cloud.yml
bundle exec kitchen test
```
or
```
rake integration:cloud
```
