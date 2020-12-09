import numpy as np
from keras.utils.io_utils import HDF5Matrix

hdf5_path = './image.hdf5'

x_train = HDF5Matrix(hdf5_path, 'train_img')
X_train = np.array(x_train)
y_train = HDF5Matrix(hdf5_path, 'train_labels')
y_train = np.array(y_train)

X_val = HDF5Matrix(hdf5_path, 'val_img')
X_val = np.array(X_val)
y_val = HDF5Matrix(hdf5_path, 'val_labels')
y_val = np.array(y_val)

X_test = HDF5Matrix(hdf5_path, 'test_img')
X_test = np.array(X_test)
y_test = HDF5Matrix(hdf5_path, 'test_labels')
y_test = np.array(y_test)




print("--------------------")
print('train :' , y_train.count([0,1]),y_train.count([1.0]), '% : ', y_train.count([0,1])/len(y_train))
print('val :' , y_val.count([0,1]),y_val.count([1.0]), '% : ', y_val.count([0,1])/len(y_val))
print('test :' , y_test.count([0,1]),y_test.count([1.0]), '% : ', y_test.count([0,1])/len(y_test))
