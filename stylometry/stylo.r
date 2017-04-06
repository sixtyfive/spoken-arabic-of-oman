#!/usr/bin/Rscript

library(stylo)
library(readr)
library(igraph)

# All this is just about reading the corpus's text files and preparing them for use with stylo
corpus.dir = '../corpus'
corpus.filenames = list.files(corpus.dir, full.names=T)
corpus = lapply(lapply(lapply(corpus.filenames, read_file), strsplit, ' '), '[[', 1)
corpus.textnames = gsub(".*\\/([[:alnum:]]+)_([[:alnum:]]+)_([[:alnum:]]+)\\.txt", "\\1", corpus.filenames) # Group 1: short name. Group 2: author. Group 3: work.
names(corpus) = corpus.textnames

# From the docs: stylo() returns a result object comprised of the following:
#           distance.table  final distances between each pair of samples
#                 features  features (e.g. words, n-grams, ...) applied to data
#   features.actually.used  features (e.g. frequent words) actually analyzed
#       frequencies.0.culling  frequencies of words/features accross the corpus
#               list.of.edges  edges of a network of stylometric similarities
#        table.with.all.freqs  frequencies of words/features accross the corpus
#           table.with.all.zscores  z-scored frequencies accross the corpus
results = stylo(parsed.corpus = corpus, gui=F)

# First output the distance table directly as plain text
results$distance.table
# Now output a visualisation of the matrix in the form of a network diagram
png('distance_graph.png', width=1600, height=1600, unit='px')
g = graph.adjacency(results$distance.table, mode='undirected', weighted=T)
plot(g, layout=layout_with_kk, vertex.color='white', vertex.label.cex=3, vertex.label.color='black')
dev.off()
