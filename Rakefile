#encoding: utf-8

task :default => [:test]

task :test do
  ruby "test/test.rb"
end

namespace :test do

  desc "Unitary tests. Fasts and on the sources."
  task :test do
    ruby "test/test.rb"
  end

  desc "Functional tests. Slow, test real the features under real conditions of usage."
  task :functional do
    ruby "test/functional.rb"
  end
end
