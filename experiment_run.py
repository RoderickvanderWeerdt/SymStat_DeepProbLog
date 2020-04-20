#changes made to use the sudoku data instead of the addition data

from train import train_model
from data_loader import load
from examples.NIPS.MNIST.mnist import test_MNIST, MNIST_Net, neural_predicate
from model import Model
from optimizer import Optimizer
from network import Network
from torch.autograd import Variable
import torch
import torchvision
import torchvision.transforms as transforms
import numpy as np
import os
path = os.path.abspath(__file__)
dir_path = os.path.dirname(path)



# train_queries = load('train_data.txt')
# train_queries = load('train.txt')
test_queries = load('4x4_sudokus_0open.pl')[:100]
# global iteration_n

def test(model):
    global iteration_n
    acc = model.accuracy(test_queries, test=True,verbose=False)
    print('Accuracy: ', acc)
    # iteration_n = iteration_n +1
    # create_digit2(model, 5, iteration_n)
    return [('accuracy', acc)]

i = 0
while i <= 32:
    with open('sudoku_mini.pl') as f:
        problog_string = f.read()
    with open('new_digits2_' + str(i) + '.pl') as f:
        problog_string += f.read()
    i += 1


    network = MNIST_Net()
    net = Network(network, 'mnist_net', neural_predicate)
    net.optimizer = torch.optim.Adam(network.parameters(),lr = 0.001)
    model = Model(problog_string, [net], caching=False)
    optimizer = Optimizer(model, 2)
    # iteration_n = 0

    test(model)
    # train_model(model,train_queries, 1, optimizer,test_iter=1000,test=test,snapshot_iter=1000)
