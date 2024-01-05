import numpy as np
import matplotlib.pyplot as plt

# Read grayscale numbers from a file
file_path = "C:/Vivaldo/Project/result.txt"

with open(file_path, "r") as file:
    # Read each line and convert values to integers
    grayscale_numbers = [int(line.strip()) for line in file]

# Convert the 1D array to a 2D array (49x49)
grayscale_array = np.array(grayscale_numbers).reshape(49, 49)

# Display the image
plt.imshow(grayscale_array, cmap='gray', vmin=0, vmax=20)
plt.colorbar()
plt.show()