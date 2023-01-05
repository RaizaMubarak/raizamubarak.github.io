import pandas as pd
import os
import datetime
import matplotlib.pyplot as plt
from itertools import combinations
from collections import Counter 

##Reading the csv files

files =[file for file in os.listdir('/Users/mac/Desktop/py-project/VirtualEnv/Sales_Data')]

# for file in files:
#     print(file)

all_data = pd.DataFrame()
for file in files:
    df = pd.read_csv("/Users/mac/Desktop/py-project/VirtualEnv/Sales_Data/" + file)
    all_data = pd.concat([all_data,df])


all_data.to_csv("all_data.csv", index = False)

final_data = pd.read_csv("all_data.csv")


##Dropping the rows that are not relevent
final_data.drop(final_data[final_data['Order ID'] == 'Order ID'].index, inplace = True)
final_data.dropna(how = 'all', inplace= True)
final_data.reset_index(drop=True, inplace=True)
#print(final_data.head(5))

##Which month had the most sales and how much

final_data['Order Date'] = pd.to_datetime(final_data['Order Date'])
final_data['Year'] = final_data['Order Date'].dt.year

final_data['Month'] = final_data['Order Date'].dt.month

final_data['Quantity Ordered'] = final_data['Quantity Ordered'].astype('int32')
final_data['Price Each'] = final_data['Price Each'].astype('float')
final_data['Revenue'] = final_data['Quantity Ordered'] * final_data['Price Each']
#print(final_data.head())

results = final_data.groupby('Month').sum()
# print(results)

#Plotting the sales Vs Month
months = range(1,13)
plt.bar(months,results['Revenue'])

plt.xticks(months)
plt.ylabel("Sales in USD ($)")
plt.xlabel("Month Number")
plt.savefig("SalesMonth")


##Which City had the most sales and how much

final_data['City']= final_data['Purchase Address'].apply(lambda x : x.split(',')[1])

city_revenue = final_data.groupby('City').sum()
#print(city_revenue)
cities = final_data['City'].sort_values().unique()
#print(cities)
##Plotting the sales vs cities
figure = plt.figure()
plt.bar(cities, city_revenue['Revenue'])
plt.show()
plt.xticks(cities, rotation = 'vertical', size = 8)
plt.xlabel("Cities")
plt.ylabel("Sales in USD ($)")
plt.savefig("CitySales")



##Which time is good for advertisement

final_data['Hour'] = final_data['Order Date'].dt.strftime('%H')
final_data['Date'] = final_data['Order Date'].dt.date
#print(final_data.head())

hourly_sales = final_data.groupby('Hour').mean()
#print(hourly_sales)

Hour = final_data['Hour'].sort_values().unique()
#print(Hour)

#Plotting the hours vs sales

plt.plot(Hour,hourly_sales['Revenue'])
plt.ylabel("Average Sales in USD ($)")
plt.grid()
plt.xlabel("Hours")
plt.savefig("Hourly Sales")

##Which Product was sold most
Total_Quan = final_data.groupby('Product').sum()

products = final_data['Product'].sort_values().unique()
#print(products)

plt.bar(products,Total_Quan['Quantity Ordered'])
plt.xticks(products,rotation ='vertical', size = 8)
plt.xlabel("Product Names")
plt.ylabel("Total Sold")
plt.savefig("ProductSales")

##Which two products were together
df = final_data[final_data['Order ID'].duplicated(keep=False)]

df['Grouped'] = df.groupby('Order ID')['Product'].transform(lambda x:','.join(x))
df = df[['Order ID', 'Grouped']].drop_duplicates()

count = Counter()
for row in df['Grouped']:
    row_list = row.split(',')
    count.update(Counter(combinations(row_list,2)))

for key,value in count.most_common(10):
    print(key, value)
