#!/usr/bin/Rscript

library(mallet)
library(wordcloud)

documents = mallet.read.dir('../corpus/cleaned')
mallet_instances = mallet.import(documents$id, documents$text, 'stoplist.txt')
topic_model = MalletLDA(num.topics = 5)
topic_model$loadDocuments(mallet_instances)
vocabulary = topic_model$getVocabulary()
word_frequencies = mallet.word.freqs(topic_model)
topic_model$setAlphaOptimization(20, 50)
topic_model$train(400)
topic_model$maximize(10)
document_topics = mallet.doc.topics(topic_model, smoothed=T, normalized=T)
topic_words = mallet.topic.words(topic_model, smoothed=T, normalized=T)

head(word_frequencies)
mallet.top.words(topic_model, topic_words[1,])
mallet.top.words(topic_model, topic_words[2,])
mallet.top.words(topic_model, topic_words[3,])
mallet.top.words(topic_model, topic_words[4,])
mallet.top.words(topic_model, topic_words[5,])

top_words = mallet.top.words(topic_model, topic_words[5,])

png('mallet_output/wordcloud.png', width=1000, height=1000, unit='px')
wordcloud(top_words$words, top_words$weights, c(20,1), rot.per=0, random.order=F)
dev.off()
