import os 
import numpy as np
import pandas as pd
import tensorflow as tf

from tensorflow import keras

from tensorflow.keras import layers
'''
    author : Sungwoo Park
    version : 1.0
    base_model : MobileNet V2
    create date : 2020.11.16
    
'''


def create_model(inputs, classes, training = True, fine_tune_at = -1):
    base_model = tf.keras.applications.MobileNetV2(input_shape= inputs,
                                               include_top=False,
                                               weights='imagenet')

  

    fine_tune = fine_tune_at
    base_model.trainable = True
    for layer in base_model.layers[:fine_tune]:
        layer.trainable = False

    layer_dict = dict([(layer.name, layer) for layer in base_model.layers])

    x = layer_dict[list(layer_dict.keys())[-1]].output 
    GAP = layers.GlobalAveragePooling2D()(x)
    Flatten = layers.Flatten()(GAP)
    Output = layers.Dense(classes, activation='softmax')(Flatten)

    model = keras.Model(inputs = base_model.input, outputs =  Output)


    return model



if __name__ == '__main__':
    model = create_model(inputs= (224,224,3), classes =2 ,fine_tune_at= -3)
    print(model.summary())
    
    