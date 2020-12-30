import coremltools

from keras.models import load_model
from keras import layers

#model = load_model('./bestmask.h5')
model = load_model('./dummy.h5')
layer_dict = dict([(layer.name, layer) for layer in model.layers])
input_layer = layer_dict[list(layer_dict.keys())[0]].name
output_layer = layer_dict[list(layer_dict.keys())[-1]].name
labels = ['correct', 'incorrect']

#model.summary()


print(input_layer)
#print(type(input_layer))
print(output_layer)
#print(type(output_layer))

coreml_model = coremltools.converters.keras.convert(model,
                                                    input_names= input_layer,
                                                    output_names= output_layer,
                                                    class_labels= labels)

coreml_model.author = 'Sungwoo Park'
coreml_model.license = 'DUSASAE'
coreml_model.short_description = 'Mask Detection using MobilenetV2'
coreml_model.output_description['classLabel'] = 'Correct or incorrect wearing mask'

coreml_model.save('MaskModel.mlmodel')

