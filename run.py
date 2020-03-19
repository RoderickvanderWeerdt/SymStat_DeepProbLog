#changes made to use the sudoku data instead of the addition data

from train import train_model
from data_loader import load
from examples.NIPS.MNIST.mnist import test_MNIST, MNIST_Net, neural_predicate
from model import Model
from optimizer import Optimizer
from network import Network
import torch


train_queries = load('train_data.txt')
test_queries = load('4x4_sudokus_0open.pl')[:100]


def test(model):
    acc = model.accuracy(test_queries, test=True)
    print('Accuracy: ', acc)
    return [('accuracy', acc)]


with open('sudoku_mini.pl') as f:
    problog_string = f.read()

network = MNIST_Net()
net = Network(network, 'mnist_net', neural_predicate)
net.optimizer = torch.optim.Adam(network.parameters(),lr = 0.001)
model = Model(problog_string, [net], caching=False)
optimizer = Optimizer(model, 2)

test(model)
train_model(model,train_queries, 1, optimizer,test_iter=1000,test=test_MNIST,snapshot_iter=10000)