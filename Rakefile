#encoding: utf-8

task :default => [:test]

task :test do
  ruby "test/test.rb"
end

namespace :test do
  task :test do
    ruby "test/test.rb"
  end

  task :functional do
    ruby "test/functional.rb"
  end
end
