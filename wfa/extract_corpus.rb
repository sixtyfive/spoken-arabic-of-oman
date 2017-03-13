#!/usr/bin/env ruby

unless ARGV.length > 1
  puts "Usage: extract_corpus.rb <contents directory> <thirdparty scripts directory> <raw corpus file> <cleaned corpus file>"
  exit
end

File.open(ARGV[2], 'w') do |corpus|
  Dir.glob("#{ARGV[0]}/transcript??.tex").sort.each do |file|
    File.open(file, 'r') do |contents|
      linecount = 0
      while line = contents.gets
        # First option: 3- or 4-column (multiple speakers) transcripts.
        # Second option: 2- or 3-column (single speaker) transcripts.
        # Regex fishes Arabic text out of enclosing LaTeX commands, but still leaves footnotes, etc. in!
        unless (/^\\ara{\\href{.*\.mp3}{(?<result>.*)}} (&|\\\\)$/ =~ line).nil?
          corpus.puts result.gsub(/\\.*{.*}/, '') # Should now get rid of any contained LaTeX artefacts.
          linecount += 1
        end
      end
      puts "#{File.basename(file)}: wrote #{linecount} lines."
    end
  end
end

%x{#{ARGV[1]}/basic_ortho_norm.py < #{ARGV[2]} > #{ARGV[3]}}
