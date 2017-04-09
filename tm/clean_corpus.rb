#!/usr/bin/env ruby

require 'pathname'
require 'fileutils'

wfa_dir = Pathname('../wfa')
require_relative wfa_dir+'regex_replacement_table'
replacement_tables = Dir.glob(wfa_dir+'*_replacement_table.txt')
corpus_dir = Pathname('../corpus')
corpus_files = Dir.glob(corpus_dir+'OA*txt')

corpus_files.each do |corpus_file|
  file_contents = IO.read(corpus_file)
  file_contents.gsub!(/.: /, '') # speaker designations ("x: ") need to be removed first
  @regex_replacements.each {|search,replace| file_contents.gsub!(search, replace)}
  replacement_tables.each do |replacement_table|
    File.open(replacement_table, 'r') do |manual_tokenisation_file|
      while line = manual_tokenisation_file.gets
        unless line.include? '#' # comment line
          search, replace = line.strip.split(',')
          file_contents.gsub!(/\s#{search}\s/, " #{replace} ")
        end
      end
    end
  end
  # none of the R scripts would know what
  # to do with the roman numbers that were
  # introduced by the replacement tables
  file_contents.gsub!(/[IVXLCDMap-]/, '')
  # don't want extraneous whitespace either
  file_contents.gsub!(/\s+/, ' ')
  # write cleaned texts back into files
  FileUtils.mkdir_p corpus_dir+'cleaned'
  new_file = corpus_dir+'cleaned'+File.basename(corpus_file)
  File.open(new_file, 'w') {|new_file| new_file.puts file_contents}
end
