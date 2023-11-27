from flask import Flask, jsonify
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib as mpl
import numpy as np

mpl.style.use('ggplot')

# Load your CSV file
car = pd.read_csv('Cleaned_Car_data.csv')

# Create a pie chart for the distribution of fuel types
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

# Count the number of cars for each company
company_counts = car['company'].value_counts()

# Plot the bar chart
company_counts.plot(kind='bar', color='skyblue')

# Get the required values for drawing the plot
bar_chart_data = {
    'labels': company_counts.index.tolist(),
    'values': company_counts.values.tolist()
}

# Close the plot to prevent it from being displayed
plt.close()

# Flask application
app = Flask(__name__)

@app.route('/')
def calculate_fuel_distribution():
    # Read the CSV file
    df = pd.read_csv('Cleaned_Car_data.csv')

    # Count the number of cars for each fuel type
    fuel_counts = df['fuel_type'].value_counts()

    # Convert the result to a dictionary for easy jsonify
    result = {'fuel_distribution': pie_chart_data,
              'number_of_cars_by_company': bar_chart_data}

    # Commit changes with a specific message
    commit_message = "Update data and calculate fuel distribution"

    # Return the result as JSON
    return jsonify(result)

if __name__ == '__main__':
    # Run the Flask application
    app.run(debug=True)