#encoding: utf-8

require 'colorize'

task :default => [:test]

task :test do
  ruby "test/test.rb"
end

namespace :test do

  desc "Unitary tests. Fasts and on the sources."
  task :test do
    puts
    ruby "test/test.rb"
  end

  desc "Functional tests. Slow, test real the features under real conditions of usage."
  task :functional do
    puts "!!! Important !!!".yellow
    puts "You have to access to internet to test the generator.".yellow
    puts
    ruby "test/functional.rb"
  end
end
