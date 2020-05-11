#changes made to use the sudoku data instead of the addition data
#added some explicit test function here, because importing caused problems

from train import train_model
from data_loader import load
from examples.NIPS.MNIST.mnist import MNIST_Net, neural_predicate
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



train_queries = load('train.txt')
#test_queries = load('4x4_sudokus_0open.pl')[:100]
test_queries = load('9x9_sudokus_0open.pl')[:100]

# Definitions---------------------------------------------------
transform = transforms.Compose([transforms.ToTensor(), transforms.Normalize((0.5,), (0.5, ))])
mnist_test_data = torchvision.datasets.MNIST(root=dir_path+'/data/MNIST', download=False,transform=transform)


def test_MNIST(model,max_digit=10,name='mnist_net'):
    confusion = np.zeros((max_digit,max_digit),dtype=np.uint32) # First index actual, second index predicted
    N = 0
    for d,l in mnist_test_data:
        if l < max_digit:
            N += 1
            d = Variable(d.unsqueeze(0))
            outputs = model.networks[name].net.forward(d)
            _, out = torch.max(outputs.data, 1)
            c = int(out.squeeze())
            confusion[l,c] += 1
    print(confusion)
    F1 = 0
    for nr in range(max_digit):
        TP = confusion[nr,nr]
        FP = sum(confusion[:,nr])-TP
        FN = sum(confusion[nr,:])-TP
        F1 += 2*TP/(2*TP+FP+FN)*(FN+TP)/N
    print('F1: ',F1)
    return [('F1',F1)]


def test(model):
    acc = model.accuracy(test_queries, test=True,verbose=False)
    print('Accuracy: ', acc)
    return [('accuracy', acc)]


with open('sudoku_mini.pl') as f:
    problog_string = f.read()



#------Running the code-------------------------------------------------------------------------------
network = MNIST_Net()
net = Network(network, 'mnist_net', neural_predicate)
net.optimizer = torch.optim.Adam(network.parameters(),lr = 0.001)
model = Model(problog_string, [net], caching=False)
optimizer = Optimizer(model, 2)


test(model)
train_model(model,train_queries, 1, optimizer,test_iter=1000,test=test,snapshot_iter=10000)
