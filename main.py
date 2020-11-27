import os.path  
import make_model
import make_dataset
import train_model
import matplotlib.pyplot as plt

    
if __name__ == "__main__":
    inputs = (224,224,3)
    classes = 2
    fine_tune_at = 100           
    train_model.train(inputs, classes, fine_tune_at)
