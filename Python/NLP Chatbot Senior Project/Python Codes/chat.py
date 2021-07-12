#Import
import random
import json
import torch
from model import NeuralNet
from nltk_tools import bag_of_words, tokenize

#using CPU instead of GPU
device = torch.device('cpu')

#open the json file in read mode 
with open('intents.json', 'r') as f:
	intents = json.load(f)
	
#Get the same information from data.pth
FILE = "data.pth"
data = torch.load(FILE)


input_size = data["input_size"]
hidden_size = data["hidden_size"]
output_size = data["output_size"]
all_words = data["all_words"]
tags = data["tags"]
model_state = data["model_state"]

#load FFNN from models.py
model = NeuralNet(input_size, hidden_size, output_size).to(device)

#change models state to evaluation
model.load_state_dict(model_state)
model.eval()	



#implement actual chatbot
bot_name = "Dan"
print("\nHi, I'm Dan, service bot for Master Toddy's LA Pomona"
		"\nAsk me anything about our Gym.  type 'quit' to exit.\n")
while True:
	sentence = input('You: ')
	if sentence == "quit":
		break
	
	#take the original sentence, tokenize them, and reshape them into a torch tensor
	sentence = tokenize(sentence)
	X = bag_of_words(sentence, all_words)
	X = X.reshape(1, X.shape[0])
	X = torch.from_numpy(X)
	
	#Predict what kind of sentence was it and tag is appropriately
	output = model(X)
	_, predicted = torch.max(output, dim=1)
	tag = tags[predicted.item()]
	
	probs = torch.softmax(output, dim=1)
	prob = probs[0][predicted.item()]
	
	#If 80% or more likely to be the correct tag, answer the question
	if prob.item() > 0.80:
		for intent in intents["intents"]:
			if tag == intent["tag"]:
				print(f"{bot_name}: {random.choice(intent['responses'])}")
				print()
				
	else:
		print(f"{bot_name}: I do not understand...\nFor specific questions, please call (626)383-9957 and ask for Carol.")
		print()