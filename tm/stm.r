#!/usr/bin/Rscript

library(stm)
library(readr)

# Read the corpus from the text files it resides in and also store those files' names
corpus.dir = '../corpus/cleaned'
corpus.filenames = list.files(corpus.dir, pattern='OA.*', full.names=T) # Only the Omani Arabic texts!
corpus.raw = lapply(corpus.filenames, read_file)

# Feed the corpus into the topic modelling algorithm
processed = textProcessor(corpus.raw) #, customstopwords=read_file('stoplist.txt'))
out = prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh=1) # Don't throw away any terms as we don't have enough anyways
num_topics = 3
models = stm(documents=out$documents, vocab=out$vocab, K=num_topics, init.type='Spectral') # Max number of topics that can be determined
models.selection_data = selectModel(out$documents, out$vocab, K=num_topics, runs=10, seed=120000)
models.selected = models.selection_data$runout[[2]]

# Plot list of topics and associated terms, then plot a comparison between the top two topics
png('stm_output/model_info.png', width=1000, height=1000, unit='px')
plotModels(models.selection_data)
png('stm_output/summary.png', width=500, height=500, unit='px')
plot(models.selected)
lapply(1:num_topics, function(topic) {
  png(paste0('stm_output/topic', topic, '.png'), width=500, height=500, unit='px')
  cloud(models.selected, topic=topic, scale=c(7,.5))
})
png('stm_output/top_models_comparison.png', width=1000, height=1000, unit='px')
plot(models.selected, type='perspectives', topics=c(1, 2))
dev.off()
