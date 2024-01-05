import numpy as np
from numpy import asarray

from keras.models import Sequential
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import AveragePooling2D
from keras.layers import Flatten
from keras.layers import *

import time

# Read data from a file
file_path = "C:/Code Python/images/test_100x100/result.txt"  # Replace with the actual file path
with open(file_path, "r") as file:
    # Read each line, convert values to integers, and create a 1D array
    data = [int(line.strip()) for line in file]

# Convert the 1D array to a 2D array (100x100)
data_size = 100
data = np.asarray(data).reshape(1, data_size, data_size, 1)

kernel = [[[[0]], [[-1]], [[0]]],
           [[[-1]], [[4]], [[-1]]],
           [[[0]], [[-1]], [[0]]]]
weights = [asarray(kernel), asarray([0.0])]

# Create model with Conv2D and MaxPooling2D
model = Sequential()
model.add(Conv2D(1, (3, 3), input_shape=(data_size, data_size, 1)))
model.add(MaxPooling2D(pool_size=(2, 2)))  # MaxPooling2D with 2x2 pool size
model.summary()

start_time = time.time()  # Record start time

model.set_weights(weights)
yhat = model.predict(data)

# Convert negative values to 0
yhat[yhat < 0] = 0

# Write the output to a file
output_file_path = "C:/Code Python/images/test_100x100/final_output.txt"  # Replace with the desired output file path
with open(output_file_path, "w") as output_file:
    for r in range(yhat.shape[1]):
        output_file.write("\n".join(str(int(yhat[0, r, c, 0])) for c in range(yhat.shape[2])))
        output_file.write("\n")

end_time = time.time()  # Record end time
runtime = end_time - start_time
print(f"Runtime: {runtime} seconds")