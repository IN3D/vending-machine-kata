Vending Machine Kata
===
You can see the Kata's requirements [here](https://github.com/guyroyse/vending-machine-kata).

This repo contains a `.ruby-version` file, so if you are using rvm, it should
automatically switch to ruby version 2.2.3, provided it is installed.

The `Gemfile` contains all the requirements for the project. To install them
simply use bundler like so:
```
bundle install
```

Tests can be run with rspec from the command line:
```
rspec
```

For nicer output, append the color flag:
```
rspec --color
```

All files were linted with Rubocop, to run this linter. Go to the root of the
project and run:
```
rubocop
```
All files should pass inspection.
