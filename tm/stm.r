#!/usr/bin/Rscript

library(stm)
library(readr)

# read the corpus from the text files it resides in and also store those files' names
corpus.dir = '../corpus/cleaned'
corpus.raw = read.csv(paste0(corpus.dir, '/', 'oa.csv'))
processed = textProcessor(corpus.raw$documents, corpus.raw) #, customstopwords=read_file('stoplist.txt'))
out = prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh=1) # don't throw away any terms as we don't have enough anyways

# not really relevant for such a small corpus, but good to keep around not to forget about
png('stm_output/removal_scenarios.png', width=1000, height=1000, unit='px')
plotRemoved(processed$documents, lower.thresh = seq(1, 10, by=1))

num_topics = 5 # max number of topics that can be determined

fit = stm(documents=out$documents, vocab=out$vocab, K=num_topics, data=out$meta, init.type='Spectral')

# not needed when using Spectral init type
# models.selection_data = selectModel(out$documents, out$vocab, K=num_topics, runs=10, seed=120000)
# models.selected = models.selection_data$runout[[2]]
# plot list of topics and associated terms
# png('stm_output/model_info.png', width=1000, height=1000, unit='px')
# plotModels(fit)

png('stm_output/summary.png', width=500, height=500, unit='px')
plot(fit)

# comparisons
lapply(1:num_topics, function(topic) {
  png(paste0('stm_output/topic', topic, '.png'), width=500, height=500, unit='px')
  cloud(fit, topic=topic, scale=c(7,.5))
})

png('stm_output/top_models_comparison.png', width=1000, height=1000, unit='px')
plot(fit, type='perspectives', topics=c(1, 2))

# fit = stm(documents=out$documents, vocab=out$vocab, K=num_topics, prevalence=~type, content=~type, max.em.its=75, data=out$meta, init.type='Spectral')
# lapply(1:num_topics, function(topic) {
#   png(paste0('stm_output/contrast', topic, '.png'), width=750, height=750, unit='px')
#   plot(fit, type='perspectives', topics=topic)
# })

dev.off()
