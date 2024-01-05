from PIL import Image
import numpy as np

def convert_to_grayscale(input_image_path, output_image_path):
    # Open the image file
    image = Image.open(input_image_path)

    # Convert the image to grayscale
    grayscale_image = image.convert('L')

    # Save the grayscale image
    grayscale_image.save(output_image_path)

def convert_and_scale_to_grayscale_matrix(input_image_path, output_file_path):
    # Open the image file
    image = Image.open(input_image_path)

    # Convert the image to grayscale
    grayscale_image = image.convert('L')

    # Convert the image to a NumPy array
    grayscale_array = np.array(grayscale_image)

    # Define the bin edges for digitization (adjust the number of bins as needed)
    bin_edges = np.linspace(0, 255, 17)[:-1]  # Use 16 bins

    # Digitize the array values into 16 bins
    digitized_array = np.digitize(grayscale_array, bin_edges) - 1

    # Write each element to the output file
    with open(output_file_path, 'w') as file:
        for value in digitized_array.flatten():
            file.write(str(value) + '\n')

def convert_to_binary_and_write(input_file_path, output_file_path):
    # Read the input file
    with open(input_file_path, 'r') as input_file:
        # Read each line and convert the numbers to 4-bit binary
        binary_values = [format(int(number), '04b') for number in input_file.readlines()]

    # Write each binary value to the output file
    with open(output_file_path, 'w') as output_file:
        for binary_value in binary_values:
            output_file.write(binary_value + '\n')

######################################################################
# Convert original image to grayscale image
input_image_path = 'C:/Code Python/images/test_100x100/red_car_2.png'
output_image_path = 'C:/Code Python/images/test_100x100/red_car_gray.png'

convert_to_grayscale(input_image_path, output_image_path)
######################################################################


######################################################################
# Convert grayscale image to a file with each elements (decimal value from 0 - 15) 
# of grayscale matrix in a single line
input_image_path = 'C:/Code Python/images/test_100x100/red_car_gray.png'
output_file_path = 'C:/Code Python/images/test_100x100/grayscale_input1.txt'

convert_and_scale_to_grayscale_matrix(input_image_path, output_file_path)

######################################################################


######################################################################
# Convert decimal value to binary 4 bits
input_file_path = 'C:/Code Python/images/test_100x100/grayscale_input1.txt'
output_file_path = 'C:/Vivaldo/Project/grayscale_input2.txt'

convert_to_binary_and_write(input_file_path, output_file_path) 
######################################################################