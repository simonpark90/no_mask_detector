import os.path  
import make_model
import make_dataset
import train_model
import matplotlib.pyplot as plt

def drow_plot(history):
    
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
if __name__ == "__main__":
    inputs = (224,224,3)
    classes = 2
    fine_tune_at = -3        
    file = './img_data.npy'    

    if os.path.isfile(file):
        history = train_model.train(inputs, classes, fine_tune_at)
        drow_plot(history)
    else:
        make_dataset.CreateDataset()
        history = train_model.train(inputs, classes, fine_tune_at)
        drow_plot(history)