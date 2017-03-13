@regex_replacements = [
  # remove Latin punctuation, Arabic numerals and control characters
  [/[[:punct:][:digit:][:cntrl:]]/, ' '],
  # remove sic
  [/sic/, ''],
  # remove Arabic and non-standard punctuation characters
  [/[؟،ـ–…]/, ' '],
  # remove Indian numerals
  [/[٠١٢٣٤٥٦٧٨٩]/, ' '],
  # remove sukūn, šadda, fatḥa, fatḥatān, ḍamma, ḍammatān, kasra, kasratān
  [/[\u0651\u0652\u064e\u064b\u064f\u064c\u0650\u064d]/, ''],
  # replace ālif and hamza with ālif only (wise?)
  ['[أإآ]', 'ﺍ'],
  # replace lām-ālif-ligature with discrete lām and ālif
  ['ﻻ', 'لا'],
  # isolated-form baʾ's should be the regular variant
  ['ﺏ', 'ب'],
  # take care of stuttering (not real words, we don't want to count them)
  [/ (تح|الع|خم|لل|خ|س|ع|ف|م|و|ي) /, ' '],
  # split the definite article "al" and whatever follows it while making sure not to rip apart the
  # following (all given without hamza, which has already been removed earlier in all instances):
  # - aḷḷāh, ilah
  # - ala
  # - allī, allaḏī/alaḏī, allatī/alatī, allaḏīna, allatīna, allawātī
  # - alān
  # - all words ending in "al + tāʾ marbūṭa"
  [/(^| )(ال)(?!(له|ه|ة|ى|لي|لذي|ذي|لتي|تي|لذين|لتين|لواتي|ان))/, ' \2 '],
  # pull apart "particle bi/li/ka/fa/wa/sa + definite article al + word"
  [/(^| )(ب|ل|ك|ف|و|س)(ال)(.*?)( |$)/, ' \1 \2 \3 ']
]
