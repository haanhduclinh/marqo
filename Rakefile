# frozen_string_literal: true

require 'bundler/gem_tasks'

task :default do
  system 'rake --tasks'
end

task :test do
  system 'rspec .'
end

task :check do
  system 'rubocop .'
end

task :check_end_test do
  system 'rubocop . && rspec .'
end
