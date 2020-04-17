from train import train_model
from data_loader import load
from examples.NIPS.MNIST.mnist import MNIST_Net, neural_predicate
import torch
from network import Network
from model import Model
from optimizer import Optimizer


train_queries = load('train.txt')
test_queries = load('4x4_sudokus_0open.pl')[:100]
global accList

def test(model):
    acc = model.accuracy(test_queries, test=True)
    print('Accuracy: ', acc)
    accList.append(acc[0][1])
    print(accList)
    return [('accuracy', acc)]


with open('sudoku_mini.pl') as f:
    problog_string = f.read()

network = MNIST_Net()
net = Network(network, 'mnist_net', neural_predicate)
net.optimizer = torch.optim.Adam(network.parameters(), lr=0.001)
model = Model(problog_string, [net], caching=False)
optimizer = Optimizer(model, 2)
accList = []

test(model)
train_model(model,train_queries, 1, optimizer, test_iter=1000, test=test, snapshot_iter=10000)

