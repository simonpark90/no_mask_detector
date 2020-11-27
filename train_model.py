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
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.model_selection import train_test_split


'''
    author : Sungwoo Park
    version : 1.3
    base_model : MobileNet V2
    early_stopping: 50
    optimizers: Adam
    create date : 2020.11.16
    fixed data : 2020.11.27
'''

def train(inputs, classes, fine_tune_at):
   
    # np_load_old = np.load
    # np.load = lambda *a,**k: np_load_old(*a, allow_pickle=True, **k)
    
    # X_train, X_test, y_train, y_test = np.load('./img_data.npy')
    batch_size = 32
    train_datagen = ImageDataGenerator(
        rescale = 1./225,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=False,
        validation_split=0.2)
    test_datagen = ImageDataGenerator(rescale = 1./255)

    train_generator = train_datagen.flow_from_directory(
        'data/train',
        target_size = (224,224),
        batch_size = batch_size,
        class_mode = 'categorical',
        subset = 'training'
    )
    validation_generator = train_datagen.flow_from_directory(
        'data/train',
        target_size = (224,224),
        batch_size = batch_size,
        class_mode = 'categorical',
        subset = 'validation'
    )
    test_generator = test_datagen.flow_from_directory(
        'data/test',
        target_size = (224,224)
    )
    
    model = make_model.create_model(inputs, classes, fine_tune_at)

    model.compile(loss='binary_crossentropy',optimizer='Adam',metrics=['accuracy'])

    modelpath="best_model_mask_classification.h5"
 
    checkpointer = cp(filepath=modelpath, monitor='val_loss', verbose=1, save_best_only=True)
    early_stopping_callback = es(monitor='val_loss', patience=50)
 
    # Learning and save models
    history =  model.fit_generator(
        train_generator,
        steps_per_epoch = train_generator.samples // batch_size,
        validation_data = validation_generator,
        validation_steps = validation_generator.samples // batch_size,
        epochs = 50000,
        callbacks=[checkpointer, early_stopping_callback]
    )
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
    
    probabilities = model.predict_generator(generator=test_generator)

if __name__ == '__main__':
   train(inputs= (224,224,3), classes =2, fine_tune_at= -3)
   




