import torchvision
import random

testset = torchvision.datasets.MNIST(root='data/', train=False, download=True)

def sort_testset():
	result = {1: [0, []], 2: [0, []], 3: [0, []], 4: [0, []], 5: [0, []], 6: [0, []], 7: [0, []], 8: [0, []], 9: [0, []], 0: [0, []]}
	for i, number in enumerate(testset):
		result[number[1]][1].append(i)
	# for number in result.keys():
	# 	print(number, len(result[number][1]))
	return result

def prolog_format_sudoku(sudoku_size, filename, n_remove):
	test_dict = sort_testset()
	# print(test_dict[5])
	if sudoku_size * sudoku_size < n_remove:
		return 0 #can't remove more numbers then there are fields
	new_filename = filename.split('.')[0][:-7] + '_' + str(n_remove) + 'open.pl'
	with open(filename) as sudoku_file:
		with open(new_filename, 'w') as new_sudoku_file:
			sudoku_file.readline() #skip header
			for sudoku in sudoku_file.readlines():
				# print(sudoku)
				i = 0
				sudoku = sudoku[2:-3].split('],[')
				new_sudoku = []
				for row in sudoku:
					for number in row.split(','):
						number = int(number)
						# print(number)
						try:
							new_sudoku.append(test_dict[number][1][test_dict[number][0]])
						except:
							test_dict[number][0] = 0
							new_sudoku.append(test_dict[number][1][test_dict[number][0]])
						test_dict[number][0] += 1
				sudoku = new_sudoku
				while i < n_remove:
					random_coor = (random.randint(1, sudoku_size*sudoku_size))
					if sudoku[random_coor-1] != '_':
						sudoku[random_coor-1] = '_'
						i += 1
					else:
						continue
				# print(str(new_sudoku))
				new_sudoku_file.write('sudoku(' + str(new_sudoku).replace('\'', '') + ',Solution).\n')
				# return 0




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


prolog_format_sudoku(4, '4x4_sudokus_solved.txt', 5)

