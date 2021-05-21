import nltk
#nltk.download('punkt') #punkt is a pre-trained tokenizer so word_tokenize work
#disabled because already downloaded

#import a stemmer from NLTK
from nltk.stem.porter import PorterStemmer
stemmer = PorterStemmer()

import numpy as np


#tokenizing is to take a sentence, and split them to a list of individual words
def tokenize(sentence):
    return nltk.word_tokenize(sentence);
	
	#from the nltk package, use the function word_tokenize, 
	#a pretrained tokenizer, then pass your sentence
	
	
	
#stemming is to trim a word into a more general version of the word
#example: acting -> act, acted -> act
def stem(word):
    return stemmer.stem(word.lower())
	
	#stem the word and lower case everything
	
	
def bag_of_words(tokenized_sentence, all_words):
	tokenized_sentence = [stem(w) for w in tokenized_sentence]
	bag = np.zeros(len(all_words), dtype = np .float32)
	for index, w, in enumerate(all_words):
		if w in tokenized_sentence:
			bag[index] = 1.0
			
	return bag
	
