import os, re, glob
import cv2
import numpy as np
import pandas as pd
import tensorflow as tf
import make_model 
import tables


from tensorflow import keras
from tensorflow.keras import models
from tensorflow.keras.callbacks import EarlyStopping as es, ModelCheckpoint as cp
from tensorflow.keras import optimizers
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.model_selection import train_test_split

from random import shuffle
from math import ceil
from matplotlib import pyplot as plt


'''
    author : Sungwoo Park
    version : 1.4
    base_model : MobileNet V2
    early_stopping: 50
    optimizers: Adam
    create date : 2020.11.16
    fixed data : 2020.12.02
'''

def train(inputs, classes, fine_tune_at):
   
    hdf5_path = './image.hdf5'
    subtract_mean = False
    batch_size = 32


    hdf5_file = tables.open_file(hdf5_path, mode = 'r')

    if subtract_mean:
        mm = hdf5_file.root.train_mean[0]
        mm = mm[np.newaxis, ...]
    data_num = hdf5_file.root.train_img.shape[0]

    batch_list = list(range(int(ceil(float(data_num)/batch_size))))
    shuffle(batch_list)

    for n, i in enumerate(batch_list):
        i_s = i * batch_size
        i_e = min([i+1*batch_size,data_num])

        images = hdf5_file.root.train_img[i_s:i_e]
        if subtract_mean:
            images -= mm

        labels = hdf5_file.root.train_labels[i_s:i_e]
        labels_one_hot = np.zeros((batch_size,nb_class))
        labels_one_hot[np.arange(batch_size),labels] = 1

        print(n+1,'/',len(batch_list))

        print 
    # train_datagen = ImageDataGenerator(
    #     rescale = 1./225,
    #     shear_range=0.2,
    #     zoom_range=0.2,
    #     horizontal_flip=False,
    #     validation_split=0.2)
    # test_datagen = ImageDataGenerator(rescale = 1./255)

    # train_generator = train_datagen.flow_from_directory(
    #     'data/train',
    #     target_size = (224,224),
    #     batch_size = batch_size,
    #     class_mode = 'categorical',
    #     subset = 'training'
    # )
    # validation_generator = train_datagen.flow_from_directory(
    #     'data/train',
    #     target_size = (224,224),
    #     batch_size = batch_size,
    #     class_mode = 'categorical',
    #     subset = 'validation'
    # )
    # test_generator = test_datagen.flow_from_directory(
    #     'data/test',
    #     target_size = (224,224)
    # )
    
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
   




