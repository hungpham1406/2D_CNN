# 2D_CNN

# REMEMBER TO CHANGE DIRECTORY PATH IN ALL SOURCE CODE FILE TO YOUR DESIRED DIRECTORY PATH

# Folder "Source_Code_Verilog
- The file "read_txt2.v" is the TOP module in verilog's design sources
- "read_txt2_tb.v" is the test bench file using for simulation
- "grayscale_input2" is the input file generated from grayscale image
- "Arty-Z7-20-Master.xdc" is the constraint file used to config I/O ports for the board Arty-Z7-20 when you want to upload the code.

 # Folder "Source_Code_Python"
- "origin_image_to_grayscale_input.py": This file is used to convert the original image into grayscale value (with each pixel of the image has only 1 value).
- "Convolution-2D.py": After running the "origin_image_to_grayscale_input.py" file successfully, we will have input for convolution calculating in this file.
- "draw_from_grayscale.py": When we have the output file after running "Convolution-2D.py" or run the simulation for verilog source code successfully to get the output file, we can use this file to draw the grayscale image from output obtained.
- "compare_2_files.py": This file is used to compare the 2 output files of "Convolution-2D.py" and verilog simulation.
