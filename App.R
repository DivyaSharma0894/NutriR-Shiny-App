library(shiny)
library(shinydashboard)
library(tidyverse)
library(tidytext)
library(plotly)
library(SnowballC)
library(tm)
library(httr)
library(DT)
library(caTools)
library(xgboost)  # Load xgboost library

google_client_id <- "360020239888-2ve4fim7kbp105hm62lne8ecpspqu7ld.apps.googleusercontent.com"
google_client_secret <- "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"

# Define the OAuth scopes
scopes <- c("https://www.googleapis.com/auth/userinfo.profile",
            "https://www.googleapis.com/auth/userinfo.email")

# Define UI
ui <- navbarPage(
  title = "NutriR- your personalised nutrition assistant",
  id = "tabs",
  inverse = FALSE,
  
  header = tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;700&display=swap",
      rel = "stylesheet"
    ),
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap",
      rel = "stylesheet"
    ),
    tags$style(HTML("
    html{
    scroll-behavior:smooth;
    }
     body {
  font-family: 'Roboto', sans-serif !important;
  font-size: 14px;
  margin: 0;
  padding: 0;
  background-color: #f4f7f9; /* Slightly lighter shade */
}

.navbar {
  background-color: #F7E7CE !important; /* Softer Peach */
  border-color: #F7E7CE !important;
  margin-bottom: 0;
  position: sticky;
  top: 0;
  z-index: 1000;
}

.navbar .navbar-brand,
.navbar .navbar-nav > li > a {
  color: #003366 !important; /* Slightly darker blue for better contrast */
  font-weight: bold !important;
  font-size: 16px;
}

.navbar .navbar-nav {
  float: right !important;
}

.navbar .navbar-nav > li > a:hover {
  background-color: #ffdcb6 !important; /* Softer hover color */
  color: #003366 !important;
}

.hero-section {
  position: relative;
  background: linear-gradient(
      rgba(0, 0, 0, 0.3),
      rgba(0, 0, 0, 0.6),
      rgba(0, 0, 0, 0.3)
    ),
    url('https://static.vecteezy.com/system/resources/thumbnails/027/599/318/small_2x/top-view-of-a-broad-variety-of-perfect-nutrition-food-ingredients-for-healthy-life-photo.jpg');
  background-size: cover;
  background-position: center;
  height: 90vh; /* Slightly reduced height */
  color: white;
  text-align: center;
  padding-top: 180px; /* Adjusted padding for better positioning */
  padding-bottom: 20px;
  margin-bottom: 0;
}

.hero-section h1 {
  font-size: 2.8em; /* Increased size slightly */
  font-weight: bold;
  margin-bottom: 15px; /* Reduced margin */
}

.hero-section p {
  font-size: 1.2em;
  margin-bottom: 20px; /* Reduced margin */
  color:white;
}

.hero-section .btn,.btn1 {
  font-size: 16px;
  padding: 10px 22px; /* Adjusted padding for consistent button sizing */
  background-color: #2db83d; /* Softer Peach */
  color: white;
  border: none;
  border-radius: 50px;
  font-weight: bold;
  margin:10px;
  transition: all 0.3s ease-in-out;
  width:200px;
}
.hero-section .btn1{
border:5px solid ##2db83d;
color:##2db83d;
background-color:grey;

}


.hero-section .btn:hover {
  background-color: white; /* Deep Blue */
  color: ##2db83d;
  border:5px solid ##2db83d;
  transform: scale(1.05); /* Added slight hover effect */
}
.hero-section .btn1:hover{
background-color:#003366;
color:white;
border:none;

}

.section {
  padding: 25px 20px; /* Adjusted padding */
  text-align: center;
  background-color: #f6f9fc; /* Softer Light Gray */
  margin-bottom: 20px;
}

.section h3 {
  font-size: 2.4em; /* Increased size */
  color: #003366; /* Deep Blue */
  margin-bottom: 15px; /* Adjusted margin */
  color:#003366;
}

.section .feature-box {
  margin-top: 20px;
  border-radius: 10px;
  padding: 18px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Slightly stronger shadow */
  background-color: #2db83d;
  transition: box-shadow 0.3s ease-in-out;
   transition: box-shadow 0.3s ease-in-out;
   color:white;
   width:33%;
   display:inline-block;
}

.section .feature-box:hover {
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2); /* Added hover effect */
  transform: scale(1.02);
}
.section .feature-box p{
color:white;
}
.cta-section{
text-align:center;
}
.cta-buttons {
  display: flex;
  justify-content: center;
  gap: 20px; /* Adjusted spacing */
  margin-top: 20px;
}

.cta-buttons .btn {
  width: 180px;
  font-size: 16px;
  padding: 12px;
  border-radius: 12px; /* Slightly sharper edges */
 background-color: #F7E7CE; /* Softer Peach */
  color: #003366;
  font-weight:bold;
  transition: all 0.3s ease-in-out;
  border:none;
}

.cta-buttons .btn:hover {
  background-color: #003366; /* Soft Aqua */
  color:white;
  transform: scale(1.05); /* Added scale effect */
}

   #UPLOAD PAGE   
      


h3 {
    color: #3b5998;
    font-weight: bold;
    margin-bottom: 15px;
}

p {
    font-size: 14px;
    color: #555;
}

.step-box .btn {
    background-color: #003366;
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 16px;
    cursor: pointer;
    transition: all 0.3s ease-in-out;
}


@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.step-container {
  margin-bottom: 20px;
   animation: fadeIn 1.2s ease-in-out; 
}

.step-box {
  background-color: #f5f5f5;
  padding: 15px;
  margin: 10px 0;
  border-radius: 10px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.step-box h3 {
  color: #003366;
}

  


/* Prediction Steps Layout */
.prediction-steps-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30px;
  padding: 20px;
  
}
.prediction-steps-container h2{
color:#003366;
font-weight:bold;
font-size:40px;
}

.prediction-steps-container .step-box {
width:500px;
  align-items: center;
  margin: 15px 0;
  padding: 20px;
  background-color: #ffffff;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.prediction-steps-container .step-box:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

.step-icon {
  font-size: 30px;
  color: #003366;
  margin-right: 20px;
}

.step-content h4 {
  font-size: 1.5em;
  color: #2A4D70;
}

.step-content p {
  font-size: 1em;
  color: #505050;
}

/* Button and Result Styling */
.box .btn-predict {
  background-color: #003366;
  color: white;
  font-size: 16px;
  padding: 12px 20px;
  border-radius: 5px;
}

#result-container {
  text-align: center;
  background-color: #f1f1f1;
  padding: 40px 20px;
  margin-top: 40px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

#result-container h3 {
  font-size: 2em;
  color: #2A4D70;
}

#prediction-result {
  font-size: 3em;
  font-weight: bold;
  color: #D32F2F;
  margin-top: 20px;
  font-family:'IBM Plex Mono',cursive
}
.prediction-steps-container .step-box {
  opacity: 0;
  transform: translateY(20px);
  animation: fadeInUp 0.5s forwards;
}

@keyframes fadeInUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Apply this animation to each step with different delays */
.prediction-steps-container .step-box:nth-child(1) {
  animation-delay: 0.2s;
}
.prediction-steps-container .step-box:nth-child(2) {
  animation-delay: 0.4s;
}
.prediction-steps-container .step-box:nth-child(3) {
  animation-delay: 0.6s;
}
.prediction-steps-container .step-box:nth-child(4) {
  animation-delay: 0.8s;
}



/* Sidebar styling */
/* Instruction Section for 2D Graphs */
.instruction-container {
  text-align: center;
  background: linear-gradient(to right, #99d9e4, #003366); /* Blue Gradient */
  color: white;
  padding: 30px;
  border-radius: 10px;
  margin-bottom: 20px;
}

.instruction-container h2 {
  font-size: 2em;
  margin-bottom: 10px;
}

.animation-box {
  margin-top: 20px;
  animation: bounce 2s infinite;
}

.icon-large {
  font-size: 40px;
  color: #fff;
}

/* Input Columns for 2D Graphs */
.input-columns {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
}

Bhavya College, [26-11-2024 18:35]
.input-columns .col-sm-6 {
  margin-right: 10px;
}

/* Spinner for 2D Graphs */
#loading-spinner-2d {
  text-align: center;
  margin-top: 20px;
  color: #003366;
  font-size: 24px;
}






/* Instruction Section */
.instruction-container {
  text-align: center;
  background: linear-gradient(to right, #ffffff, #205e1a);
  color: white;
  padding: 30px;
  border-radius: 10px;
  margin-bottom: 20px;
}

.instruction-container h2 {
  font-size: 2em;
  margin-bottom: 10px;
}

.animation-box {
  margin-top: 20px;
  animation: bounce 2s infinite;
}

.icon-large {
  font-size: 40px;
  color: #fff;
}

/* Animation Keyframes */
@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

/* Input Columns Styling */
.input-columns {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
   animation: fadeIn 0.5s ease-in-out;
}

.input-columns .col-sm-4 {
  margin-right: 10px;
}

/* Spinner */
#loading-spinner {
  text-align: center;
  margin-top: 20px;
  color: #2db83d;
  font-size: 24px;
}







/* Styling for Google Login Button */
.btn-google-login {
    background-color: #db4437;
    color: white;
    font-size: 16px;
    border-radius: 5px;
    width: 100%;
    padding: 10px;
    transition: all 0.3s ease;
}

.btn-google-login:hover {
    background-color: #c1351d;
}

/* Instruction Box Styling */
.login-instruction-container {
    background: linear-gradient(to right, #fbbc77, #003366);
    border-radius: 15px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
   
}

.login-instruction-container h2 {
    color: white;
    font-weight: bold;
}

.login-instruction-container .animation-box {
    font-size: 50px;
    color: #db4437;
    margin-top: 20px;
}

/* User Info Styling */
.user-info-container .box {
    background-color: #f0f8ff;
    border-radius: 10px;
}

.user-info-container .box h4 {
    font-size: 18px;
    font-weight: bold;
    color: #003366;
}






  
    "))
  ),
  
  
  
  
  
  tabPanel(
    "Home",
    div(
      class = "hero-section",
      h1("Welcome to Nutri R"),
      p(
        "Your personalized diet and nutrition assistant. Plan meals, track calories, and achieve your health goals."
      ),
      actionButton("explore_button", "START EXPLORING", class = "btn", 
                   onclick = "document.getElementById('mission').scrollIntoView({behavior: 'smooth'});"),
      actionButton("login_button", "GET STARTED", class = "btn1")
    ),
    
    div(
      class = "section", id = "mission",
      h3("Our Mission"),
      p(
        "Nutri R aims to simplify healthy living by offering personalized diet recommendations, real-time calorie tracking, and nutrition insights tailored to your unique needs."
      ),
      div(
        class = "features-container",
        div(
          class = "feature-box",
          tags$i(
            class = "fa fa-apple-alt",
            style = "font-size: 50px; color: #90EE90;"
          ),
          h4("Personalized Diet Plans"),
          p("Receive tailored meal recommendations based on your health goals and preferences.")
        ),
        div(
          class = "feature-box",
          tags$i(
            class = "fa fa-calculator",
            style = "font-size: 50px; color: #FFCCCB;"
          ),
          h4("Calorie Tracking"),
          p("Monitor your daily calorie intake and stay on track with your goals.")
        ),
        div(
          class = "feature-box",
          tags$i(
            class = "fa fa-chart-pie",
            style = "font-size: 50px; color: #ADD8E6;"
          ),
          h4("Nutrition Insights"),
          p("Analyze the nutritional content of your meals and make healthier choices.")
        )
      )
    ),
    
    div(
      class = "cta-section",
      h3("Get Started Today"),
      p("Choose one of the tools below to begin your health journey."),
      div(
        class = "cta-buttons",
        actionButton(
          "go_to_plan",
          "Generate Meal Plan",
          icon = icon("utensils"),
          class = "btn btn-success"
        ),
        actionButton(
          "go_to_tracking",
          "Track Calories",
          icon = icon("chart-line"),
          class = "btn btn-warning"
        ),
        actionButton(
          "go_to_analysis",
          "Nutrition Analysis",
          icon = icon("chart-pie"),
          class = "btn btn-info"
        )
      )
    )
  ),
  # Other tab panels here...
  tabPanel("BMI",
           fluidRow(
             column(12,
                    div(class = "instruction-container",
                        h2("Generate Your BMI"),
                        p("Enter your weight and height to calculate your BMI and check your health status.")
                    )
             ),
             column(12,
                    box(
                      title = "BMI Calculator", width = 12,
                      solidHeader = TRUE,
                      status = "primary",
                      collapsible = TRUE,
                      numericInput("weight", "Weight (kg):", value = 70),
                      numericInput("height", "Height (m):", value = 1.75),
                      actionButton("calculate_bmi", "Calculate BMI", class = "btn btn-primary"),
                      actionButton("calculate_calorie_target", "Determine Calorie Target", class = "btn btn-primary")
                    )
             ),
             column(12,
                    div(id = "bmi-result-container",
                        h3("BMI Calculation Result"),
                        textOutput("bmi_output"),
                        h3("Calorie Target Result"),
                        textOutput("calorie_target_output")
                    )
             )
           )
  )
  ,
  tabPanel("Upload Data",
           fluidRow(
             column(12,
                    div(class = "instruction-container",
                        h2("Analyze Your Nutrition"),
                        p("Upload a dataset to analyze the nutritional content of your meals.")
                    )
             ),
             column(12,
                    fileInput("nutrition_file", "Upload Nutrition Data (CSV)", accept = ".csv"),
                    actionButton("analyze_data", "Analyze", class = "btn-analyze"),
                    plotOutput("nutrition_chart")
             )
           )
  ),
  
  # "Meal Plan" tab to generate meal plan based on uploaded data
  tabPanel("Meal Plan",
           fluidRow(
             column(12,
                    div(class = "instruction-container",
                        h2("Generate Your Meal Plan"),
                        p("Enter your preferences to generate personalized meal plan recommendations.")
                    )
             ),
             column(12,
                    box(
                      title = "Generate Meal Plan", width = 12,
                      solidHeader = TRUE,
                      status = "primary",
                      collapsible = TRUE,
                      actionButton("generate_meal_plan", "Generate Meal Plan", class = "btn btn-primary")
                    )
             ),
             column(12,
                    div(id = "meal-plan-output-container",
                        h3("Meal Plan Recommendations"),
                        uiOutput("meal_plan_output")
                    )
             )
           )
  ),
  tabPanel("Login",
           fluidRow(
             column(12,
                    div(class = "login-container",
                        h2("Login to Access Your Dashboard"),
                        actionButton("login_btn", "Login", class = "btn-login")
                    )
             )
           )
  )
)


server <- function(input, output, session) {
  # Reactive value to store user data
  user_data <- reactiveVal(NULL)
  
  # OAuth function for Google login
  observeEvent(input$login_btn, {
    req(input$login_btn)
    
    # Google OAuth authentication setup
    google_app <- oauth_app("google", key = "google_client_id", secret = "google_client_secret")
    google_token <- oauth2.0_token(
      oauth_endpoints("google"),
      google_app,
      scope = "email",
      cache = FALSE
    )
    
    # Retrieve user information
    user_info <- httr::GET("https://www.googleapis.com/oauth2/v2/userinfo", config(token = google_token))
    user_info_data <- httr::content(user_info)
    
    # Display user information
    output$user_info <- renderText({
      paste("Hello,", user_info_data$name)
    })
    
    # Store user data in reactive variable
    user_data(user_info_data)
    
    # Show modal dialog on successful login
    showModal(modalDialog(
      title = "Welcome!",
      paste("You have successfully logged in as", user_info_data$email),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  
  # Redirect to Login tab
  observeEvent(input$login_button, {
    updateNavbarPage(session, "Nutri R: Diet Recommender App", selected = "Login")
  })
  
  # BMI Calculation logic
  observeEvent(input$calculate_bmi, {
    req(input$weight, input$height)
    
    # Calculate BMI
    bmi <- input$weight / (input$height ^ 2)
    
    # Determine BMI category
    bmi_category <- if (bmi < 18.5) {
      "Underweight"
    } else if (bmi >= 18.5 & bmi < 24.9) {
      "Normal weight"
    } else if (bmi >= 25 & bmi < 29.9) {
      "Overweight"
    } else {
      "Obese"
    }
    
    # Output BMI result and category
    output$bmi_output <- renderText({
      paste("Your BMI is:", round(bmi, 2), "-", bmi_category)
    })
    
    # Store BMI in session for calorie target calculation
    session$userData$bmi <- bmi
  })
  
  # Determine calorie target based on BMI
  observeEvent(input$calculate_calorie_target, {
    req(session$userData$bmi)
    bmi <- session$userData$bmi
    
    calorie_target <- if (bmi < 18.5) {
      2800
    } else if (bmi >= 18.5 && bmi < 24.9) {
      2500
    } else if (bmi >= 25 && bmi < 29.9) {
      2200
    } else {
      2000
    }
    
    output$calorie_target_output <- renderText({ 
      paste("Recommended Daily Calorie Target:", calorie_target, "calories")
    })
    
    # Store calorie target in session if needed
    session$userData$calorie_target <- calorie_target
  })
  
  # Calorie Tracker logic
  observeEvent(input$add_meal, {
    req(input$meal_name, input$calories)
    
    # Add meal data to reactive value
    if (is.null(user_data()$calorie_log)) {
      user_data()$calorie_log <- data.frame(Meal = character(), Calories = numeric())
    }
    new_entry <- data.frame(Meal = input$meal_name, Calories = input$calories)
    user_data()$calorie_log <- rbind(user_data()$calorie_log, new_entry)
    
    # Update calorie log table
    output$calorie_log <- renderTable({
      user_data()$calorie_log
    })
  })
  
  # Nutrition Insights logic
  observeEvent(input$analyze_data, {
    req(input$nutrition_file)
    
    # Load the uploaded file
    nutrition_data <- read.csv(input$nutrition_file$datapath)
    
    # Check if there are at least two numeric columns for plotting
    numeric_cols <- sapply(nutrition_data, is.numeric)
    if (sum(numeric_cols) >= 2) {
      # Select the first two numeric columns for chart
      plot_data <- nutrition_data[, numeric_cols][, 1:2]
      
      output$nutrition_chart <- renderPlot({
        # Plot the data (e.g., scatter plot between two numeric fields)
        plot(plot_data[, 1], plot_data[, 2], 
             xlab = colnames(plot_data)[1], ylab = colnames(plot_data)[2], 
             main = "Nutritional Data Comparison", 
             pch = 19, col = "blue")
      })
    } else {
      output$nutrition_chart <- renderPlot({
        plot(1, type = "n", xlab = "", ylab = "", main = "Not enough numeric data for plotting")
      })
    }
  })
  
  # Server logic for "Upload Data"
  observeEvent(input$analyze_data, {
    req(input$nutrition_file)
    
    # Load and analyze the uploaded file
    nutrition_data <- read.csv(input$nutrition_file$datapath)
    
    # Show a plot using the uploaded data (e.g., a plot between calories and protein)
    output$nutrition_chart <- renderPlot({
      if("Calories" %in% colnames(nutrition_data) && "Protein" %in% colnames(nutrition_data)) {
        plot(nutrition_data$Calories, nutrition_data$Protein,
             xlab = "Calories", ylab = "Protein",
             main = "Calories vs Protein Content",
             pch = 19, col = "blue")
      } else {
        plot(1, type = "n", xlab = "", ylab = "", main = "Missing necessary columns (Calories, Protein)")
      }
    })
    
    # Save the nutrition data in session for use in meal plan generation
    session$userData$nutrition_data <- nutrition_data
  })
  # Server logic for "Meal Plan"
  observeEvent(input$generate_meal_plan, {
    req(session$userData$nutrition_data)
    
    # Get the nutrition data from session
    nutrition_data <- session$userData$nutrition_data
    
    # Check if calorie target exists
    if (is.null(session$userData$calorie_target)) {
      output$meal_plan_output <- renderUI({
        tags$div(style = "color: red;", "Please calculate your calorie target first in the BMI section!")
      })
      return()
    }
    
    # Get the calorie target
    calorie_target <- session$userData$calorie_target
    
    # Select relevant columns from nutrition data
    selected_data <- nutrition_data[, c("name", "serving_size", "calories")]
    
    # Set calorie targets for each meal
    breakfast_calories <- 0.25 * calorie_target
    lunch_calories <- 0.40 * calorie_target
    dinner_calories <- 0.35 * calorie_target
    
    # Function to select food items based on calorie needs
    select_foods <- function(calories_needed, selected_data) {
      selected_foods <- list()
      total_calories <- 0
      remaining_data <- selected_data
      max_servings <- 4
      
      for (i in 1:100) {
        if (total_calories >= calories_needed || nrow(remaining_data) == 0) break
        food_row <- sample(1:nrow(remaining_data), 1)
        food <- remaining_data[food_row, ]
        food_calories <- food$calories
        servings_needed <- ceiling((calories_needed - total_calories) / food_calories)
        servings_needed <- min(servings_needed, max_servings)
        
        if (servings_needed > 0) {
          selected_foods <- c(selected_foods, paste(servings_needed, "servings of", food$name))
          total_calories <- total_calories + (servings_needed * food_calories)
        }
        
        remaining_data <- remaining_data[-food_row, ]
      }
      
      warning_message <- if (total_calories < calories_needed) {
        paste("This meal plan will achieve", round(total_calories, 0), "of", round(calories_needed, 0), "desired calories.")
      } else {
        NULL
      }
      
      list(selected_foods = selected_foods[1:4], total_calories = total_calories, warning = warning_message)
    }
    
    # Generate meal plan for each meal (Breakfast, Lunch, Dinner)
    breakfast_plan <- select_foods(breakfast_calories, selected_data)
    lunch_plan <- select_foods(lunch_calories, selected_data)
    dinner_plan <- select_foods(dinner_calories, selected_data)
    
    # Combine all meals into a full meal plan
    full_meal_plan <- c(breakfast_plan$selected_foods, lunch_plan$selected_foods, dinner_plan$selected_foods)
    total_calories <- breakfast_plan$total_calories + lunch_plan$total_calories + dinner_plan$total_calories
    warning_message <- if (!is.null(breakfast_plan$warning)) {
      breakfast_plan$warning
    } else if (!is.null(lunch_plan$warning)) {
      lunch_plan$warning
    } else if (!is.null(dinner_plan$warning)) {
      dinner_plan$warning
    } else {
      NULL
    }
    
    # Show meal plan output in UI
    output$meal_plan_output <- renderUI({
      tagList(
        h4("Recommended Meal Plan:"),
        p(paste("Total Calories: ", round(total_calories, 0))),
        if (!is.null(warning_message)) {
          tags$div(style = "color: red;", warning_message)
        },
        tableOutput("meal_plan_table")
      )
    })
    
    # Display the meal plan in a table format
    output$meal_plan_table <- renderTable({
      data.frame(Meal = c("Breakfast", "Lunch", "Dinner"),
                 Foods = c(paste(breakfast_plan$selected_foods, collapse = ", "),
                           paste(lunch_plan$selected_foods, collapse = ", "),
                           paste(dinner_plan$selected_foods, collapse = ", ")))
    })
  })
  
  # Modal logic for actions
  observeEvent(input$ok_button, {
    removeModal()
  })
  
  # Handle navigation actions
  observeEvent(input$go_to_plan, {
    updateNavbarPage(session, "Nutri R: Diet Recommender App", selected = "Meal Plans")
  })
  
  observeEvent(input$go_to_tracking, {
    updateNavbarPage(session, "Nutri R: Diet Recommender App", selected = "Calorie Tracker")
  })
  
  observeEvent(input$go_to_analysis, {
    updateNavbarPage(session, "Nutri R: Diet Recommender App", selected = "Nutrition Insights")
  })
}

# Run the application
shinyApp(ui = ui, server = server, options = list(port = 1702))
