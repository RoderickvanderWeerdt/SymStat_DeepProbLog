import torchvision
import random

testset = torchvision.datasets.MNIST(root='data/', train=False, download=True)

def sort_testset(sudoku_size):
	result = {}
	i = 1
	while i <= sudoku_size:
		result.update({i: [0, []]})
		i += 1
	for i, number in enumerate(testset):
		try:
			result[number[1]][1].append(i)
		except:
			# print("number", number[1], "is not used in this sudoku, so can be skipped.")
			continue
	# for number in result.keys():
	# 	print(number, len(result[number][1]))
	return result

def prolog_format_sudoku(sudoku_size, filename, n_remove, list_of_lists=False):
	test_dict = sort_testset(sudoku_size)
	if sudoku_size * sudoku_size < n_remove:
		return 0 #can't remove more numbers then there are fields
	new_filename = filename.split('.')[0][:-7] + '_' + str(n_remove) + 'open.pl'
	with open(filename) as sudoku_file:
		with open(new_filename, 'w') as new_sudoku_file:
			sudoku_file.readline() #skip header
			sudoku_counter = 0
			for sudoku in sudoku_file.readlines():
				if sudoku_counter >= 1000: break
				else: sudoku_counter += 1
				# print(sudoku)
				i = 0
				sudoku = sudoku[2:-3].split('],[')
				new_sudoku = []
				new_sudoku_solved = []
				for row in sudoku:
					for number in row.split(','):
						number = int(number)
						# print(number)
						try:
							new_sudoku.append(test_dict[number][1][test_dict[number][0]])
						except:
							test_dict[number][0] = 0
							new_sudoku.append(test_dict[number][1][test_dict[number][0]])
						new_sudoku_solved.append(number)
						test_dict[number][0] += 1
				sudoku = new_sudoku
				while i < n_remove:
					random_coor = (random.randint(1, sudoku_size*sudoku_size))
					if sudoku[random_coor-1] != '_':
						sudoku[random_coor-1] = '_'
						i += 1
					else:
						continue
				if list_of_lists:
					new_sudoku = []
					i = 0
					while i < sudoku_size*sudoku_size:
						new_sudoku.append(sudoku[i:i+sudoku_size])
						i += sudoku_size
					sudoku = new_sudoku
				new_sudoku_file.write('sudoku(' + str(sudoku).replace('\'', '') + ',' + str(new_sudoku_solved) + ').\n')
				# return 0

# def prolog_test_data(sudoku_size):
# 	test_dict = sort_testset(sudoku_size)
# 	for key in test_dict.keys():
# 		for image_id in test_dict[key][1]:
# 			print("digit2(" + str(image_id) + ', ' + str(key) + ').')
# prolog_test_data(4)

# def simple_format_sudoku(sudoku_size, filename, new_sudoku_file):
# 	with open(filename, 'r') as sudoku_file:
# 		with open(new_sudoku_file, 'w') as new_sudoku_file:
# 			print(sudoku_file.readline())
# 			for line in sudoku_file.readlines():
# 				solved_sudoku = line.split(',')[1]
# 				formated_solved = '[['
# 				counter = 0
# 				for number in solved_sudoku[:-1]:
# 					if counter < sudoku_size-1:
# 						formated_solved += number + ','
# 						counter += 1
# 					else:
# 						formated_solved += number + '],['
# 						counter = 0
# 				formated_solved = formated_solved[:-2] + ']\n'
# 				new_sudoku_file.write(formated_solved)

# format_sudoku(9, 'sudoku.csv', '9x9_sudokus_solved.txt') #https://www.kaggle.com/rohanrao/sudoku/data
# format_sudoku(4, '4x4_sudoku_unique_puzzles.csv', '4x4_sudokus_solved.txt') #https://github.com/Black-Phoenix/4x4-Sudoku-Dataset/blob/master/4x4_sudoku_unique_puzzles.csv


prolog_format_sudoku(4, '4x4_sudokus_solved.txt', 0)

