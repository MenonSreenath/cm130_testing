from itertools import product
import pandas as pd

data = pd.read_csv("products.csv")
df = pd.DataFrame(data)
print(df)
