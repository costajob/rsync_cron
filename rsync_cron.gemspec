# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rsync_cron/version"

Gem::Specification.new do |s|
  s.name = "rsync_cron"
  s.version = RsyncCron::VERSION
  s.authors = ["costajob"]
  s.email = ["costajob@gmail.com"]
  s.summary = "Install specified rsync command into crontab schedule"
  s.homepage = "https://github.com/costajob/rsync_cron"
  s.license = "MIT"
  s.required_ruby_version = ">= 2.1.8"

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir = "bin"
  s.executables << "rsync_cron"
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.15"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
end
