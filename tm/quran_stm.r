#!/usr/bin/Rscript

library(stm)
library(readr)
library(stringr)

# read the corpus from the text files it resides in and also store those files' names
corpus.dir = '../corpus/quran'
corpus.raw = read.csv(paste0(corpus.dir, '/', 'medinan-and-meccan-suras-only.csv'))
processed = textProcessor(corpus.raw$documents, corpus.raw)

# not really relevant for such a small corpus, but good to keep around not to forget about
png('quran/removal_scenarios.png', width=1000, height=1000, unit='px')
plotRemoved(processed$documents, lower.thresh = seq(1, 10, by=1))
dev.off()

threshold = 8 # removing 13788 terms, 24194 tokens
num_topics = 10 # not really sure how many topics are sensible here...
out = prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh=threshold)

# R> poliblogContent <- stm(out$documents, out$vocab, K = 20,
#    + prevalence =~ rating + s(day), content =~ rating,
#    + max.em.its = 75, data = out$meta, init.type = "Spectral")

fit = stm(documents=out$documents, vocab=out$vocab, K = num_topics,
          prevalence =~ type+s(chrono), content =~ type,
          max.em.its = 75, data=out$meta, init.type='Spectral')

png('quran/topic_summary.png', width=1000, height=1000, unit='px')
plot(fit)
dev.off()

lapply(1:num_topics, function(topic) {
  png(paste0('quran/contrast', str_pad(topic, 2, pad='0'), '.png'), width=1000, height=1000, unit='px')
  plot(fit, type='perspectives', topics=topic)
  dev.off()
})
