import keras
from keras import layers

'''
    author : Sungwoo Park
    version : 1.0
    base_model : MobileNet V2
    create date : 2020.11.16
    fixed data : 
'''


def create_model(inputs, classes):
    base_model = keras.applications.MobileNetV2(input_shape= inputs,
                                               include_top=False,
                                               weights= None)

  

    base_model.trainable = True
    
    layer_dict = dict([(layer.name, layer) for layer in base_model.layers])

    x = layer_dict[list(layer_dict.keys())[-1]].output 
    GAP = layers.GlobalAveragePooling2D()(x)
    Output = layers.Dense(classes, activation='softmax')(GAP)

    model = keras.Model(inputs = base_model.input, outputs =  Output)


    return model



if __name__ == '__main__':
    model = create_model(inputs= (224,224,3), classes =2)
    print(model.summary())
    
    
