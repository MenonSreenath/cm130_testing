from itertools import product
import panda as pd

data = pd.read_csv("products.csv")
df = pd.DataFrame(data)
print(df)
