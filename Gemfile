source "https://rubygems.org"

ruby ">= 3.0"

gem "fastlane", "2.236.0"
gem "cocoapods", "~> 1.15"
gem "multi_json"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
