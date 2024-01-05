def compare_file_contents(file1_path, file2_path):
    with open(file1_path, "r") as file1, open(file2_path, "r") as file2:
        content1 = file1.read()
        content2 = file2.read()

    # Remove white spaces before each value in file 2
    content2 = '\n'.join(line.lstrip() for line in content2.split('\n'))

    return content1 == content2

# Replace these paths with the actual paths to your output files
file1_path = "C:/Code Python/images/test_100x100/final_output.txt"
file2_path = "C:/Vivaldo/Project/result.txt"

if compare_file_contents(file1_path, file2_path):
    print("The contents of the files are the same.")
else:
    print("The contents of the files are different.")
