def increment(index):
    index_new = index + 1
    return index_new
def get_square(numb):
    return numb*numb
def print_numb(numb):
    print("Number is {}".format(numb))
    

index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))