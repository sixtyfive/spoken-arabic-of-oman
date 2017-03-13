#!/usr/bin/env ruby

require 'pathname'

f_words = []
Dir.glob(Pathname.new('../corpus')+'*.txt').each do |f|
  f_contents = File.read(f)
  f_words << f_contents.split(' ').count
end
puts f_words.inject(0, :+)/f_words.length
