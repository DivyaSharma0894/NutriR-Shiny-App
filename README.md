# NutriR: Your Personalized Nutrition Assistant

[![R Shiny](https://img.shields.io/badge/R-Shiny-blue.svg)](https://shiny.rstudio.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)  NutriR is a Shiny web application designed to help you achieve your health and fitness goals by providing personalized diet recommendations, calorie tracking, and nutrition analysis.

## Features

-   **Personalized Meal Plans:** Generate tailored meal plans based on your dietary preferences and calorie needs.
-   **Calorie Tracking:** Easily log your daily meals and monitor your calorie intake.
-   **Nutrition Insights:** Analyze nutritional data from uploaded files to make informed dietary choices.
-   **BMI Calculator:** Calculate your Body Mass Index and determine your ideal calorie target.
-   **User Authentication:** Securely log in using Google OAuth to access your personalized data.

## Screenshots
![image](https://github.com/user-attachments/assets/e0f9ae95-91ad-4816-a708-a956a5810870)

## Getting Started

### Prerequisites

-   R (>= 4.0)
-   RStudio (recommended)
-   Required R packages: `shiny`, `shinydashboard`, `tidyverse`, `tidytext`, `plotly`, `SnowballC`, `tm`, `httr`, `DT`, `caTools`, `xgboost`, `gargle`

### Installation

1.  Clone the repository:

    ```bash
    git clone [https://github.com/YourUsername/NutriR.git](https://www.google.com/search?q=https://github.com/YourUsername/NutriR.git)  # Replace with your repository URL
    cd NutriR
    ```

2.  Open the `app.R` file in RStudio.

3.  Install the required R packages:

    ```R
    install.packages(c("shiny", "shinydashboard", "tidyverse", "tidytext", "plotly", "SnowballC", "tm", "httr", "DT", "caTools", "xgboost", "gargle"))
    ```

4.  Configure Google OAuth:
    * Create a Google Cloud project and enable the Google OAuth 2.0 API.
    * Create OAuth 2.0 client IDs and download the JSON configuration file.
    * Place the client secret JSON file in a secure location.
    * Set the Google Client ID and Secret in the `app.R` file.
    * Ensure that the redirect URIs in your Google Cloud Console match your Shiny app's URL.

5.  Run the Shiny app:

    ```R
    shiny::runApp("app.R")
    ```

## Usage

1.  Navigate to the "Login" tab and log in using your Google account.
2.  Use the "BMI" tab to calculate your BMI and determine your calorie target.
3.  Upload your nutritional data in the "Upload Data" tab.
4.  Generate personalized meal plans in the "Meal Plan" tab.
5.  Track your daily calorie intake in the "Calorie Tracker" tab.
6.  Analyze your nutrition data in the "Nutrition Insights" tab.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues to report bugs or suggest new features.

## Functionality Walkthrough

### Nutritional Breakdown

The app allows users to input food items and receive a detailed breakdown of their nutritional values. The key nutritional parameters displayed include:

* Calories
* Total Fat
* Sodium
* Carbohydrates
* Fiber
* Protein
* Vitamins (A, C, D)
* Minerals (Calcium, Iron, Potassium)

By inputting the food item name or selecting it from a dropdown menu, users can view the corresponding data in an easily understandable format.

### BMI Calculation

Users can calculate their BMI by entering their height and weight into designated fields. The app computes their BMI and provides feedback on their health status (underweight, normal weight, overweight, obese).

### Calorie Requirement

To help users manage their diet, the app computes daily calorie requirements based on age, gender, weight, height, and activity level. The app uses standard formulas like the Harris-Benedict Equation to calculate Basal Metabolic Rate (BMR) and Total Daily Energy Expenditure (TDEE).

### Custom Meal Plans

Based on user preferences, goals, and dietary restrictions, the app generates personalized meal plans. Users can specify whether they aim for weight loss, maintenance, or gain; the app will suggest meals that align with their calorie and nutrient requirements.

### Uploading Nutritional Data

The app allows users to upload custom datasets in CSV format. The nutritional data in the file will be parsed and displayed within the app for analysis and meal planning.

### Google Authentication

To ensure a secure experience, the app integrates Google authentication. Users can log in using their Google account for access to saved meal plans and preferences. The setup is handled by the `shinymanager` package.

## How to Contribute

If you would like to contribute to developing the Nutrition Tracker Shiny App:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes and commit them.
4.  Push your changes to your forked repository.
5.  Create a pull request to merge your changes with the main repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

-   Thanks to the R Shiny team for providing a powerful web application framework.
-   Thanks to the developers of the R packages used in this project.

## Contact

[Divya Sharma] - [dadhichsharmadivya@gmail.com] - [(https://github.com/DivyaSharma0894)]
