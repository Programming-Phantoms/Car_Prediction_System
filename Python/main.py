from flask import Flask, jsonify
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

app = Flask(__name__)

# Load your CSV file
car = pd.read_csv('Cleaned_Car_data.csv')

@app.route('/')
def train_linear_regression():
    # Extracting features and target variable
    X = car[['name', 'company', 'kms_driven', 'fuel_type']]
    y = car['Price']

    # Convert categorical variable 'fuel_type' to dummy variables
    X = pd.get_dummies(X, columns=['fuel_type'], drop_first=True)

    # Convert categorical variable 'company' to dummy variables
    X = pd.get_dummies(X, columns=['company'], drop_first=True)

    # Drop 'name' column as it might not contribute to the model
    X = X.drop('name', axis=1)

    # Splitting the dataset into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Creating and training the linear regression model
    model = LinearRegression()
    model.fit(X_train, y_train)
    # Count the number of cars for each company
    company_counts = car['company'].value_counts()

    # Plot the bar chart
    plt.bar(company_counts.index, company_counts.values, color='skyblue')

    # Get the required values for drawing the plot
    bar_chart_data = {
        'labels': company_counts.index.tolist(),
        'values': company_counts.values.tolist()
    }

    # Save the bar chart image
    plt.savefig('bar_chart.png')

    # Close the plot to prevent it from being displayed
    plt.close()
    # Get the coefficients
    plt.subplots(figsize=(8, 8))

    # Count the number of cars for each fuel type
    fuel_counts = car['fuel_type'].value_counts()

    # Plot the pie chart
    plt.pie(fuel_counts, labels=fuel_counts.index, autopct='%1.1f%%', startangle=90)

    # Get the required values for drawing the plot
    pie_chart_data = {
        'labels': fuel_counts.index.tolist(),
        'values': fuel_counts.values.tolist()
    }

    # Save the pie chart image
    plt.savefig('pie_chart.png')

    # Close the plot to prevent it from being displayed
    plt.close()

    results = {'intercept': model.intercept_, 'coefficients': dict(zip(X.columns, model.coef_)),'bar_chart_data':bar_chart_data,'pie_chart_data':pie_chart_data}


    return jsonify({'result': results})

if __name__ == '__main__':
    # Run the Flask application
    app.run()