import numpy as np
import tables 
import glob
import cv2

from random import shuffle

shuffle_data = True
hdf5_path = './image.hdf5'
data_path = './data/*/*/*/*.jpg'

addrs = glob.glob(data_path)

labels = [0 if 'YES' in addr else 1 for addr in addrs]

if shuffle_data:
    c = list(zip(addrs, labels))
    shuffle(c)
    addrs, labels = zip(*c)


train_addrs = addrs[0:int(0.6*(len(addrs)))]
train_labels = labels[0:int(0.6*(len(labels)))]

val_addrs = addrs[int(0.6*(len(addrs))):int(0.8*(len(addrs)))]
val_labels = labels[int(0.6*(len(labels))):int(0.8*(len(labels)))]

test_addrs = addrs[int(0.8*(len(addrs))):]
test_labels = labels[int(0.8*(len(labels))):]

img_dtype = tables.UInt8Atom()

data_shape = (0,224,224,3)

hdf5_file = tables.open_file(hdf5_path, mode = 'w')

train_storage = hdf5_file.create_earray(hdf5_file.root, 'train_img', img_dtype, shape = data_shape)
val_storage = hdf5_file.create_earray(hdf5_file.root, 'val_img', img_dtype, shape = data_shape)
test_storage = hdf5_file.create_earray(hdf5_file.root, 'test_img', img_dtype, shape = data_shape)

mean_storage = hdf5_file.create_earray(hdf5_file.root, 'train_mean', img_dtype, shape=data_shape)


hdf5_file.create_array(hdf5_file.root, 'train_labels', train_labels)
hdf5_file.create_array(hdf5_file.root, 'val_labels', val_labels)
hdf5_file.create_array(hdf5_file.root, 'test_labels', test_labels)

mean = np.zeros(data_shape[1:], np.float32)

for i in range(len(train_addrs)):
    if i % 1000 == 0 and i >1:
        print('Train data: {}/{}'.format(i,len(train_addrs)))

    addr = train_addrs[i]
    img = cv2.imread(addr)
    img = cv2.resize(img, (224, 224), interpolation=cv2.INTER_CUBIC)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = cv2.normalize(img, None, 0, 1, cv2.NORM_MINMAX)
    train_storage.append(img[None])
    mean += img / float(len(train_labels))

for i in range(len(val_addrs)):
    if i % 1000 == 0 and i > 1:
        print ('Validation data: {}/{}'.format(i, len(val_addrs)))

    addr = val_addrs[i]
    img = cv2.imread(addr)
    img = cv2.resize(img, (224, 224), interpolation=cv2.INTER_CUBIC)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = cv2.normalize(img, None, 0, 1, cv2.NORM_MINMAX)


    val_storage.append(img[None])

for i in range(len(test_addrs)):
    if i % 1000 == 0 and i > 1:
        print ('Test data: {}/{}'.format(i, len(test_addrs)))

    addr = test_addrs[i]
    img = cv2.imread(addr)
    img = cv2.resize(img, (224, 224), interpolation=cv2.INTER_CUBIC)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = cv2.normalize(img, None, 0, 1, cv2.NORM_MINMAX)

    test_storage.append(img[None])

mean_storage.append(mean[None])
hdf5_file.close()
