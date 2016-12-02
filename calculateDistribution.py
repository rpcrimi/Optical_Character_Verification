import os

images = os.listdir('labeled_images/150')
alphabet = set([el.split('_')[1] for el in images])
letterCount = {name: {letter: 0 for letter in alphabet} for name in ["bobby", "sam"]}

for image in images:
	letter = image.split('_')
	letterCount[letter[0]][letter[1]] += 1

print letterCount