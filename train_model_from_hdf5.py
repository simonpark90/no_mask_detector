import os, re, glob
import cv2
import numpy as np

import make_model 
import tables

import keras
from keras import models, optimizers
from keras.callbacks import EarlyStopping as es, ModelCheckpoint as cp
from keras.utils import HDF5Matrix
from sklearn import metrics
from sklearn.preprocessing import OneHotEncoder

from random import shuffle
from math import ceil
from matplotlib import pyplot as plt


'''
    author : Sungwoo Park
    version : 1.5
    base_model : MobileNet V2
    early_stopping: 50
    optimizers: Adam
    create date : 2020.11.16
    fixed data : 2020.12.09
'''

def train(inputs, classes):
   
    hdf5_path = './image.hdf5'
    batch_size = 64
    epochs =50000

   
    X_train = HDF5Matrix(hdf5_path, 'train_img')
    X_train = np.array(X_train)
    y_train = HDF5Matrix(hdf5_path, 'train_labels')
    y_train = np.array(y_train).reshape(-1)
    y_train = np.eye(classes)[y_train]
    
    X_val = HDF5Matrix(hdf5_path, 'val_img')
    X_val = np.array(X_val)
    y_val = HDF5Matrix(hdf5_path, 'val_labels')
    y_val = np.array(y_val)
    y_val = np.eye(classes)[y_val]

    X_test = HDF5Matrix(hdf5_path, 'test_img')
    X_test = np.array(X_test)
    y_test = HDF5Matrix(hdf5_path, 'test_labels')
    y_test = np.array(y_test)
    y_test = np.eye(classes)[y_test]
    
    model = make_model.create_model(inputs, classes)
    model.compile(loss= 'binary_crossentropy',
                  optimizer= 'adam',
                  metrics=[ 'accuracy'])
    
    model.summary()	
    modelpath = 'bestmask.h5'  
    checkpointer = cp(filepath= modelpath, monitor= 'val_loss', verbose= 1, save_best_only= True)
    early_stopping_callback = es(monitor='val_loss', patience=50)
 
    history =  model.fit(X_train, y_train, epochs= epochs, batch_size= batch_size, validation_data= (X_val, y_val), shuffle= True, callbacks=[checkpointer, early_stopping_callback])
 

    plt.plot(history.history['acc'])
    plt.plot(history.history['val_acc'])
    plt.title('model accuracy')
    plt.ylabel('accuracy')
    plt.xlabel('epoch')
    plt.legend(['train', 'val'], loc='upper left')
    plt.savefig('acc.png')
    plt.close()

    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title('model loss')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.legend(['train', 'val'], loc='upper left')
    plt.savefig('loss.png')
    
    pred = model.predict(X_test)
    cm = metrics.confusion_matrix(y_test, pred)
    plt.imshow(cm, cmap=plt.cm.Blues)
    plt.xlabel("Predicted labels")
    plt.ylabel("True labels")
    plt.xticks([], [])
    plt.yticks([], [])
    plt.title('Confusion matrix ')
    plt.colorbar()
    plt.savefig('test_confusion_matrix.png')


if __name__ == '__main__':
   train(inputs= (224,224,3), classes =2, fine_tune_at= -3)
   




