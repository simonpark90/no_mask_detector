import os, re, glob
import cv2
import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split
'''
    author : Sungwoo Park
    version : 1.0
    create date : 2020.11.16
    fixed data : 
'''
def CreateDataset():
    X = []
    Y = []
    groups_folder_path = './data/'
    categories = ['with_mask', 'without_mask']
    num_classes = len(categories)
    for idex, categorie in enumerate(categories):
        label = [0 for i in range(num_classes)]
        label[idex] = 1
        image_dir = groups_folder_path + categorie + '/'
        print(image_dir)
        for dir_top, dir, file in os.walk(image_dir):
            for dir_path in dir:
                path = image_dir + dir_path
                for dir_top, dir_mid, dir_file in os.walk(path):
                    for filename in dir_file:
                        try:
                            print(path+'/'+filename)
                            img = cv2.imread(path+'/'+filename)
                            img = cv2.resize(img,(224,224))
                            X.append(img/256)
                            Y.append(label)
                        except Exception as e:
                            print(str(e))
    
 
    X = np.array(X)
    Y = np.array(Y)

    X_train, X_test, y_train, y_test = train_test_split(X,Y,stratify=Y)
    xy = (X_train, X_test, y_train, y_test)
 
    np.save("./img_data.npy", xy)
if __name__ == '__main__':
    CreateDataset()