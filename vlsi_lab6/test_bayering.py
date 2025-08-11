import numpy as np

# Parameters
N = 32  # size of the image (NxN)

# Load input pixels
with open('input_pixels2.txt', 'r') as f:
    pixels = [int(line.strip()) for line in f]

# Convert into NxN array
image = np.array(pixels, dtype=np.uint8).reshape(N, N)

# Initialize output arrays
R = np.zeros((N, N), dtype=np.uint8)
G = np.zeros((N, N), dtype=np.uint8)
B = np.zeros((N, N), dtype=np.uint8)

# Helper: Get pixel value with zero-padding if out of bounds
def get(i, j):
    if i < 0 or i >= N or j < 0 or j >= N:
        return 0
    else:
        return int(image[i, j])

# Debayering
for i in range(N):
    for j in range(N):
        if i % 2 == 0:
            if j % 2 == 0:
                # Green pixel (type II)
                G[i, j] = get(i, j)
                R[i, j] = (get(i-1, j) + get(i+1, j)) // 2
                B[i, j] = (get(i, j-1) + get(i, j+1)) // 2
            else:
                # Blue pixel
                B[i, j] = get(i, j)
                G[i, j] = (get(i-1, j) + get(i+1, j) + get(i, j-1) + get(i, j+1)) // 4
                R[i, j] = (get(i-1, j-1) + get(i-1, j+1) + get(i+1, j-1) + get(i+1, j+1)) // 4
        else:
            if j % 2 == 0:
                # Red pixel
                R[i, j] = get(i, j)
                G[i, j] = (get(i-1, j) + get(i+1, j) + get(i, j-1) + get(i, j+1)) // 4
                B[i, j] = (get(i-1, j-1) + get(i-1, j+1) + get(i+1, j-1) + get(i+1, j+1)) // 4
            else:
                # Green pixel (type I)
                G[i, j] = get(i, j)
                R[i, j] = (get(i, j-1) + get(i, j+1)) // 2
                B[i, j] = (get(i-1, j) + get(i+1, j)) // 2

# Save output to file
with open('output_rgb_reference.txt', 'w') as f:
    for i in range(N):
        for j in range(N):
            f.write(f"{R[i, j]} {G[i, j]} {B[i, j]}\n")
