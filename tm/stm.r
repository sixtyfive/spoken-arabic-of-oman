#!/usr/bin/Rscript

library(stm)
library(readr)
library(stringr)

# read the corpus from the text files it resides in and also store those files' names
corpus.dir = '../corpus/cleaned'
output.dir = 'oa'
corpus.raw = read.csv(paste0(corpus.dir, '/', 'oa.csv'))
processed = textProcessor(corpus.raw$documents, corpus.raw) #, customstopwords=read_file('stoplist.txt'))
threshold=2
num_topics = 6 # max number of topics that can be determined

out = prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh=threshold) # don't throw away any terms as we don't have enough anyways

# not really relevant for such a small corpus, but good to keep around not to forget about
png(paste0(output.dir, '/removal_scenarios.png'), width=1000, height=1000, unit='px')
plotRemoved(processed$documents, lower.thresh = seq(1, 10, by=1))
dev.off()

fit1 <- function() {
  fit = stm(documents=out$documents, vocab=out$vocab, K=num_topics, data=out$meta, init.type='Spectral')
  png(paste0(output.dir, '/topic_summary.png'), width=1000, height=1000, unit='px')
  plot(fit)
  dev.off()
  lapply(1:num_topics, function(topic) {
    png(paste0(output.dir, '/contrast', str_pad(topic, 2, pad='0'), '.png'), width=1000, height=1000, unit='px')
    cloud(fit, topic=topic, scale=c(7,.5))
    dev.off()
  })
  # png('oatexts/top_models_comparison.png', width=1000, height=1000, unit='px')
  # plot(fit, type='perspectives', topics=c(1, 2))
}

fit1()
