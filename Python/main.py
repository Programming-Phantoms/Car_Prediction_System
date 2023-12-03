from flask import Flask, jsonify
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

app = Flask(__name__)

car = pd.read_csv('carsdf.csv')
@app.route('/')
def train_linear_regression():
    import pandas as pd
    from sklearn.model_selection import train_test_split
    from sklearn.preprocessing import StandardScaler
    from sklearn.linear_model import LinearRegression

    df = pd.read_csv('encoded_x3.csv')
    X = df.drop('Price_Log', axis=1)
    y = df['Price_Log']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1)
   # print(X_test[:,5].tolist())
   #  scaler = StandardScaler()
   #  X_train = scaler.fit_transform(X_train)
   #  X_test = scaler.transform(X_test)

    model = LinearRegression()
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)

    # Count the number of cars for each company
    company_counts = car['Brand'].value_counts()

    # Plot the bar chart
    plt.bar(company_counts.index, company_counts.values, color='skyblue')
    plt.xlabel('Company')
    plt.ylabel('Number of Cars')
    plt.title('Number of Cars per Company')

    # Save the bar chart image
    plt.savefig('bar_chart.png')
    # plt.close()

    # Count the number of cars for each fuel type
    fuel_counts = car['Fuel_Type'].value_counts()

    # Plot the pie chart
    plt.pie(fuel_counts, labels=fuel_counts.index, autopct='%1.1f%%', startangle=90)
    plt.title('Distribution of Cars by Fuel Type')

    # Save the pie chart image
    plt.savefig('pie_chart.png')
    plt.close()
    results = {
        'LRM': {'y': y_test.tolist(), 'yhat': y_pred.tolist(),'coefficients':model.coef_.tolist(),'x_axis':X_test['Kilometers_Driven'].tolist()},
        'bar_chart_data': {'labels': company_counts.index.tolist(), 'values': company_counts.values.tolist()},
        'pie_chart_data': {'labels': fuel_counts.index.tolist(), 'values': fuel_counts.values.tolist()},

    }

    return jsonify({'result': results})


if __name__ == '__main__':
    # Run the Flask application
    app.run(debug=True)