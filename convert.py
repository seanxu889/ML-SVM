# -*- coding: utf-8 -*-
def convert(imgf, labelf, outf, n):
    f = open(imgf, "rb")
    o = open(outf, "w")
    l = open(labelf, "rb")

    f.read(16)
    l.read(8)
    images = []

    for i in range(n):
        image = [ord(l.read(1))]
        for j in range(28*28):
            image.append(ord(f.read(1)))
        images.append(image)

    for image in images:
        o.write(",".join(str(pix) for pix in image)+"\n")
    f.close()
    o.close()
    l.close()

convert("ABC_train-images.idx3-ubyte", "ABC_train-labels.idx1-ubyte", 
        "ABC_mnist_train.csv", 60000)
convert("ABC_test-images.idx3-ubyte", "ABC_test-labels.idx1-ubyte",
        "ABC_mnist_test.csv", 20500)                                                                          

print("Convert Finished!")