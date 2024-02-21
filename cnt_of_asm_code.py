import os


path = "C://Users//Arseny//Documents//Study//2_semester//Practicum_on_PC"
counter = 0
for i in range(2, 6):
	dir_list = os.listdir(path + "//Contest_" + str(i))
	for file_name in dir_list:
		with open(path + "//Contest_" + str(i) + "//" + file_name, 'r') as fp:
			for line in fp:
				line = line.replace(' ', '')
				line = line.replace('\n', '')
				if line:
					counter += 1


print(counter)
