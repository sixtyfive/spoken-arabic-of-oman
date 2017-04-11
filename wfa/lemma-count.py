#!/usr/bin/python
#
# Counts Arabic words with 1-10 characters in a text file.
# Counts hapaxes.
# Shadda is assumed to be equal to (1) character.
# All other diacritics and punctuation are discarded.
# Assumes tokenized UTF-8 input.

import sys
import os.path
import codecs
import re

# -------------------------------------------------------------------
# Input validation

if len(sys.argv) != 2:
	print("\nUsage: python " + __file__ + " filename\n")
	sys.exit()

this_file, filename_input = sys.argv

# -------------------------------------------------------------------
# Check that the file exists

if os.path.isfile(os.path.join(os.curdir, filename_input)) == False:
	print("\nUnable to open file " + filename_input + ". Please try again.\n")
	sys.exit()

# -------------------------------------------------------------------
# Open file, load full text, split on spaces

with codecs.open(filename_input, "r", "UTF-8") as textfile:
	text = textfile.read().split()

# -------------------------------------------------------------------
# This regex matches everything but the Arabic letters and shadda.
# It will be used to clean up words containing non-Arabic
# characters in the text. This is necessary because some tokens have
# punctuation appended at the beginning or end. The only diacritic
# included is shadda. All others are discarded.

all_but_arabic_letters = re.compile(u"[^\u0621-\u063A\u0641-\u064A\u0651]", flags=re.UNICODE)

# This regex matches any token that contains no Arabic letters.
# Used to discard Latin and punctuation tokens.

all_but_arabic_letters_in_token = re.compile(u"^[^\u0621-\u063A\u0641-\u064A\u0651]+$", flags=re.UNICODE)

# -------------------------------------------------------------------
# Filter each word found and throw away any diacritics and
# punctuation, except shadda.

lemmas = []

for word in text:
	if re.match(all_but_arabic_letters_in_token, word):	# No letters here,
		continue										# get next token.

	clean_word = re.sub(all_but_arabic_letters, "", word)
	lemmas.append(clean_word)							# Add clean word

# -------------------------------------------------------------------
# Create a unique list of lemmas using the set() built-in function.
# The list is a collection of tuples containing the lemma itself and
# the number of times it occurs in the text. List is sorted (alpha).

set_of_lemmas = []

for lemma in sorted(set(lemmas)):
	times = lemmas.count(lemma)
	set_of_lemmas.append((lemma, times))

# -------------------------------------------------------------------
# Count hapaxes

hapaxes = [lemma[0] for lemma in set_of_lemmas if lemma[1] == 1]

# -------------------------------------------------------------------
# Prepare output file

filename_output = filename_input + ".count"

with codecs.open(filename_output, "w", "UTF-8") as output:

	# Reorder the list according to frequency. The most frequent
	# lemmas go on top.
	
	output_list = sorted(set_of_lemmas, key=lambda freq: freq[1], reverse=True)
	

	# Write to the output file. Add a header with basic info.
	
	output.write("File: " + filename_input)
	output.write("\nLemmas in text: " + str(len(lemmas)) + "; ")
	output.write("unique lemmas: " + str(len(set_of_lemmas)) + "; ")
	output.write("hapaxes: " + str(len(hapaxes)) + "\n")
	
	# Column headers.
	
	output.write("LEMMA\tOCCURRENCES\n")
	for element in output_list:
		output.write(element[0] + "\t" + str(element[1]) +"\n")
	