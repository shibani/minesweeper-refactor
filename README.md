# Minesweeper2pl

Minesweeper2pl is
- a command line application that you can run Minesweeper on
- a gem that you can install and use exposed methods from to build a rails app version of the game.

## To run as a command line application

- clone from GitHub
- in terminal, cd into root of minesweeper_2pl directory
- run: `ruby bin/minesweeper_2pl`

## To install as a gem

Add this line to your application's Gemfile:

```ruby
gem 'minesweeper_2pl', git: 'https://github.com/shibani/minesweeper_2pl', branch:'master'
```

And then execute:

    $ bundle

## Usage

Use Minesweeper name-spaced classes to access the gem's methods.

e.g. Minesweeper::Messages will access the Messages class
and Minesweeper::Game will access the Game class within this gem.

**Useful methods**
Minesweeper::Messages.welcome
Minesweeper::Game.new(row_size, bomb_count)

## To run tests

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shibani/minesweeper_2pl. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Minesweeper2pl project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/shibani/minesweeper_2pl/blob/master/CODE_OF_CONDUCT.md).
