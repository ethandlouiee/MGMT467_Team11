# My Contributions and Learnings from this Air Quality Data Analysis Notebook

This notebook demonstrates a comprehensive exploratory data analysis (EDA) of air quality data, focusing on identifying trends and correlations among various pollutants and environmental factors. Specifically, a related scatterplot can be found here:

[Looker Studio Dashboard](https://lookerstudio.google.com/reporting/2fc71b11-3a55-45b6-8a01-d77ad5878b63/page/p_ol08d80uyd), Contribution = Scatterplot

## Key Contributions:

*   **Data Loading and Preprocessing**: Successfully loaded the `AirQuality.csv` dataset, performed initial cleanup by dropping irrelevant columns, handled missing values, and converted data types (numerical, date, and time) to appropriate formats for analysis.
*   **Time-Series Analysis of Benzene (C6H6(GT))**: Generated an interactive Plotly line chart to visualize the concentration of Benzene over time. This visualization helps in identifying temporal patterns and fluctuations in Benzene levels.
*   **Time-Series Analysis of Carbon Monoxide (CO(GT))**: Created another interactive Plotly line chart to analyze the trend of Carbon Monoxide concentration over time, revealing similar temporal insights for this pollutant.
*   **Correlation Matrix Visualization**: Developed a heatmap using Seaborn and Matplotlib to display the correlation matrix of all numerical air quality parameters. This allowed for quick identification of strong positive and negative relationships between different variables.
*   **DIVE Entry Integration**: Structured the output for each analysis with 'DIVE Entry' components, including a substantive question, interactive plots, and links to dashboard sections, making the analysis digestible and actionable.

## What I Learned:

*   **Robust Data Cleaning**: Gained practical experience in handling real-world datasets with inconsistencies (e.g., comma as decimal separator, `-200` as missing values) and converting them into a clean, analyzable format using Pandas.
*   **Effective Datetime Manipulation**: Learned to combine separate date and time columns into a single `DateTime` index, which is crucial for time-series analysis in Pandas.
*   **Interactive Visualization with Plotly Express**: Mastered creating dynamic and interactive line plots for time-series data, enabling better exploration of trends and specific data points with `hovermode="x unified"`.
*   **Interpreting Correlation Matrices**: Enhanced my ability to interpret correlation heatmaps, understanding how to identify strong relationships between variables and what those relationships might imply in the context of air quality (e.g., sensors correlating with target pollutants, inter-pollutant relationships).
*   **Structuring EDA for Clarity**: Reinforced the importance of presenting analysis steps and insights clearly, using descriptive titles, labels, and structured outputs (like the DIVE entries) to communicate findings effectively.
