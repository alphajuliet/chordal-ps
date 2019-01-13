#!/usr/bin/env rake
# Rakefile
# AndrewJ 2019-01-12


# The specific target
CHORDAL = 'output/Chordal/index.js'

desc "Build the app"
task :build => CHORDAL

# The output depends on all the source PureScript files
FileList['src/*.purs'].each do |src|
  file CHORDAL => src
end

# This is the main build command
file CHORDAL do
  system "pulp build -O"
end


desc "Run unit tests"
task :test do
  system "pulp test"
end

desc "Build to a JS executable"
task :dist do
  system "pulp build --skip-entry-point --to dist/Chordal.js"
end

desc "Build a CommonJS library"
task :bundle => :build do
  system "pulp browserify --standalone Chordal --to dist/Chordal-bundle.js"
end

desc "Run the program"
task :run => :build do
  system "pulp run"
end

desc "Run the REPL"
task :repl do
  system "pulp repl"
end


# The End
