import random




def prolog_format_sudoku(sudoku_size, filename, n_remove):
	if sudoku_size * sudoku_size < n_remove:
		return 0 #can't remove more numbers then there are fields
	new_filename = filename.split('.')[0][:-7] + '_' + str(n_remove) + 'open.pl'
	with open(filename) as sudoku_file:
		with open(new_filename, 'w') as new_sudoku_file:
			sudoku_file.readline() #skip header
			for sudoku in sudoku_file.readlines():
				i = 0
				sudoku = sudoku[2:-3].split('],[')
				new_sudoku = []
				for row in sudoku:
					new_sudoku += row.split(',')
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

				# print(new_filename)




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