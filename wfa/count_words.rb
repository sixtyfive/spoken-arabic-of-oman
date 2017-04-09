#!/usr/bin/env ruby

require 'sorting/convenience'
%w{monkey_patches create_diagram regex_replacement_table}.each |file|
  require_relative file
end

unless ARGV.count > 1
  puts "Usage: ./count_words.rb <corpus file> <word frequency file> [<replacement tables>, ...]"
  exit
end
corpus_file = ARGV[0]; output_file = ARGV[1]; corpus = File.read(corpus_file)

# Regex's first,
@regex_replacements.each {|search,replace| corpus.gsub!(search, replace)}
# then replacement tables...
ARGV.shift(2); ARGV.each do |replacement_table|
  File.open(replacement_table, 'r') do |manual_tokenisation_file|
    while line = manual_tokenisation_file.gets
      unless line.include? '#' # don't consider comment lines
        # at this point, all punctuation has been removed from the original text, so no problem
        search, replace = line.strip.split(",")
        corpus.gsub!(/\s#{search}\s/, " #{replace} ")
      end
    end
  end
end

corpus_lemmatised = corpus.gsub(/-[IVX?\/vap]{1,5}/,'').gsub(/\s+/, ' ')
potential_participles = corpus_lemmatised.scan(/ ((م[^ ]{3,7})|([^ ]ا[^ ]{1,5})) /).flatten.compact.uniq
characters = corpus_lemmatised.gsub(/\s+/, '').size
words = corpus.split(/\s+/) #.uniq.sort # only for working on the manual tokenisation file!
frequencies = Hash.new(0)
words.each {|word| frequencies[word] += 1}
frequencies = frequencies.sort_by {|x, y| [asc(y), desc(x)]}.reverse
distribution = {}
STEMS = %w(I II III IV V VI VII VIII IX X); stems = {}; %w(v pp ap).each do |c|
  stems[c] = {}; STEMS.each {|s| stems[c][s] = []}
end
verbs = []; participles = []; place = 0; verb_place = 0
last_frequency = frequencies.first.last

File.open(output_file, 'w') do |word_frequency_file|
  frequencies.each do |word, frequency|
    word = word.split('-')
    word = {:letters => word[0], :stem => (word[1] || '-'), :class => (word[2] || '-')}
    # Distribution of word frequencies across word frequency range
    (distribution[frequency] ||= 0; distribution[frequency] += 1) if last_frequency == frequency
    last_frequency = frequency
    # Verb stem count and list of verbs contained in the corpus
    STEMS.each do |roman|
      if word[:stem] == roman
        word[:class] = 'v' unless word[:class].include? 'p' # Since only participles are manually marked so far...
        unless stems[word[:class]][word[:stem]].include? word[:letters]
          stems[word[:class]][word[:stem]] << word[:letters]
        end
      end
    end
    place+=1; word_frequency_file.puts "#{place},#{frequency},#{word[:letters]},#{word[:stem]},#{word[:class]}"
  end
  counts = stems.compact.map {|stem,h| [stem, h.map {|k,v| [k, v.size]}.to_h]}.to_h # Thanks to havenwood from
  totals = counts.values.inject {|lh,rh| lh.merge(rh) {|_,x,y| x + y}}              # FreeNode#ruby for these!
  puts "Total word count: #{words.count}"
  puts "Mean word length: #{(characters.to_f / words.count.to_f).round(2)}"
  puts "Number of discrete words: #{frequencies.count}"
  puts "Mean word occurrence: #{(words.count.to_f / frequencies.count.to_f).round(2)}"
  puts "Frequency distribution: #{distribution}"
  puts "List of verbs (#{counts['v'].values.reduce(:+)}): #{stems['v']}"
  puts "List of passive participles (#{counts['pp'].values.reduce(:+)}): #{stems['pp']}"
  puts "List of active participles (#{counts['ap'].values.reduce(:+)}): #{stems['ap']}"
  puts "Stem counts: #{totals}"
  puts "Full lemmatized corpus: #{corpus_lemmatised}"
  puts "Potential participles: #{potential_participles}"
  # words.each {|word| word_frequency_file.puts word} # only for working on the manual replacement tables!
  [:distribution,:totals].each {|v| create_diagram(v, eval(v.to_s))}
end
