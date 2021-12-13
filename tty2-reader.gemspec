# frozen_string_literal: true

require_relative "lib/tty2/reader/version"

Gem::Specification.new do |spec|
  spec.name          = "tty2-reader"
  spec.version       = TTY2::Reader::VERSION
  spec.authors       = ["zzyzwicz"]
  spec.email         = ["zzyzwicz@lo0.mx"]
  spec.summary       = %q{A set of methods for processing keyboard input in character, line and multiline modes.}
  spec.description   = %q{A set of methods for processing keyboard input in character, line and multiline modes. It maintains history of entered input with an ability to recall and re-edit those inputs. It lets you register to listen for keystroke events and trigger custom key events yourself.}
  spec.homepage      = "https://github.com/zzyzwicz/tty2-reader"
  spec.license       = "MIT"
  if spec.respond_to?(:metadata=)
    spec.metadata = {
      "allowed_push_host" => "https://rubygems.org",
      "bug_tracker_uri"   => "https://github.com/zzyzwicz/tty2-reader/issues",
      "changelog_uri"     => "https://github.com/zzyzwicz/tty2-reader/blob/master/CHANGELOG.md",
      "documentation_uri" => "https://www.rubydoc.info/gems/tty2-reader",
      "homepage_uri"      => spec.homepage,
      "source_code_uri"   => "https://github.com/zzyzwicz/tty2-reader"
    }
  end
  spec.files         = Dir["lib/**/*"]
  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.0.0")

  spec.add_dependency "tty-screen", "~> 0.8"
  spec.add_dependency "tty-cursor", "~> 0.7"
  spec.add_dependency "wisper", "~> 2.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
end
