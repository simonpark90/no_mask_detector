import os, re, glob
import cv2
import numpy as np
import pandas as pd
import tensorflow as tf
import make_model 

from tensorflow import keras
from tensorflow.keras import models
from tensorflow.keras.callbacks import EarlyStopping as es, ModelCheckpoint as cp
from tensorflow.keras import optimizers
from sklearn.model_selection import train_test_split


'''
    author : Sungwoo Park
    version : 1.0
    base_model : MobileNet V2
    early_stopping:
    optimizers:
    create date : 2020.11.16
    fixed data : 
'''

def train(inputs, classes, fine_tune_at):
   
    np_load_old = np.load
    np.load = lambda *a,**k: np_load_old(*a, allow_pickle=True, **k)
    
    X_train, X_test, y_train, y_test = np.load('./img_data.npy')
    model = make_model.create_model(inputs, classes, fine_tune_at)

    model.compile(loss='binary_crossentropy',optimizer='Adam',metrics=['accuracy'])

    modelpath="mask_classification.h5"
 
    checkpointer = cp(filepath=modelpath, monitor='val_loss', verbose=1, save_best_only=True)
    early_stopping_callback = es(monitor='val_loss', patience=50)
 
    # Learning and save models
    history =  model.fit(X_train, y_train, validation_split=0.2, epochs=3500, batch_size=10, verbose=2, callbacks=[early_stopping_callback,checkpointer])
    
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
    
if __name__ == '__main__':
   train(inputs= (224,224,3), classes =2, fine_tune_at= -3)
   




