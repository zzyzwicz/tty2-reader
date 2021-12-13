
# TTY2::Reader

[![Gem Version](https://badge.fury.io/rb/tty2-reader.svg)][gem]
[![Build status](https://ci.appveyor.com/api/projects/status/d7o7e3hqq0d290n4?svg=true)][appveyor]

[gem]: http://badge.fury.io/rb/tty2-reader
[appveyor]: https://ci.appveyor.com/project/zzyzwicz/tty2-reader
[gh_actions_ci]: https://github.com/zzyzwicz/tty2-reader/actions?query=workflow%3ACI

> A tty-reader fork with the objective of adding a customized word completion mechanism.

**TTY2::Reader** intends to be an up to date clone of [TTY::Reader](https://github.com/piotrmurach/tty-reader), solely extending it with a customized word completion mechanism.
This page only covers the applied modifications.


## Modifications

* Renamed to TTY2::Reader
* Extended KeyEvent with Line object
* Added word completion

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tty2-reader"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty2-reader

* [1. API (only the modified parts)](#1-api)
  * [1.1 on](#11-on)
* [2. Configuration (only the modified parts)](#2-configuration)
  * [2.1 completion_handler](#21-completion_handler)
  * [2.2 completion_suffix](#22-completion_suffix)
  * [2.3 completion_cycling](#23-completion_cycling)

## API

### 1.1 on
You can register to listen on a key pressed events. This can be done by calling `on` with a event name(s):
```ruby
reader.on(:keypress) { |event| .... }
```
or listen for multiple events:
```ruby
reader.on(:keyctrl_x, :keyescape) { |event| ... }
```
The `KeyEvent` object is yielded to a block whenever a particular key event fires. The event responds to:

* `key`   - key pressed
* `value` - value of the key pressed
* `line`  - the `Line` object of the currently edited line, a new `Line` object with empty content otherwise

The `value` returns the actual key pressed and the `line` the content for the currently edited line or is empty.

The `key` is an object that responds to following messages:
* `name`  - the name of the event such as :up, :down, letter or digit
* `meta`  - true if event is non-standard key associated
* `shift` - true if shift has been pressed with the key
* `ctrl`  - true if ctrl has been pressed with the key
For example, to add listen to vim like navigation keys, one would do the following:
```ruby
reader.on(:keypress) do |event|
  if event.value == "j"
    ...
  end
  if event.value == "k"
    ...
  end
end
```
You can subscribe to more than one event:
```ruby
reader.on(:keypress) { |event| ... }
      .on(:keydown)  { |event| ... }
```

## Configuration

### 2.1. `:completion_handler`
This option allows you to define possible completions. It accepts a `proc` with the word that is to be completed as a first, and a context in which the word is to be completed as a second argument. By default set to nil. To use this:
```ruby
reader = TTY2::Reader.new(completion_handler: ->(word, context) { ... })
```

### 2.2. `:completion_suffix`
This option allows you to add a suffix to completed words. By default, no suffix is added. To add a suffix:
```ruby
reader = TTY2::Reader.new(completion_suffix: " ")
```

### 2.3. `:completion_cycling`
This option controls cycling through completion suggestions. By default set to `true`, and can be disabled with:
```ruby
reader = TTY2::Reader.new(completion_cycling: false)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zzyzwicz/tty2-reader.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TTY2::Reader project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotrmurach/tty-reader/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright for portions of project TTY2::Reader are held by Piotr Murach, 2017 as part of project TTY::Reader.
All other copyright for project TTY2::Reader are held by zzyzwicz, 2021.
