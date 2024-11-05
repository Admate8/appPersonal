# Tab B ----
intro_B_plot_allocations_over_time <- HTML(
  "<b>Income Allocation Chart</b><br><br>
  This chart shows the first glimpse of your broad
  spending against net income over time. It, like all charts in the dashboard,
  is interactive - you can hover over to see exact figures,
  select specific series using the legend on the left-hand side,
  or zoom in to focus on a specific period. Play with it yourself to quickly
  learn the ropes!"
)

intro_B_plot_spend_over_time <- HTML(
  "<b>Spend Breakdown Chart</b><br><br>
  This chart provides a breakdown of monthly
  expenses across various categories, represented by different colors. This
  visualisation helps track spending patterns and budgeting performance over
  time, highlighting the relative size of expenses in each category."
)

intro_B_plot_spend_over_time_perc <- HTML(
  "<b>Spend Percentage Breakdown Chart</b><br><br>
  Similar to the previous chart, but expressed as percentages of the total earnings."
)

intro_B_table_spend_comparison <- HTML(
  "<b>Spend Comparison Table</b><br><br>
  This table allows you to compare the current month's spending to the
  previous month and averages across past months. You can see the same data as
  percentages by navigating to the <em>Percentages Change</em> tab."
)

intro_B_expenses_change <- HTML(
  "<b>Spend Summary Card</b><br><br>
  Total spending change relative to historical totals."
)

intro_B_assets_change <- HTML(
  "<b>Assets Summary Card</b><br><br>
  Total assests change relative to historical totals."
)

intro_B_kpis <- HTML(
  "<b>KPIs</b><br><br>
  See how total spending and assets compare to historical data."
)

intro_B_plot_spend_breakdown <- HTML(
  "<b>Spend Breakdown Chart</b><br><br>
  This chart allows a more granular view of spending. Click on the category
  (i.e. Bills) to zoom in."
)

intro_B_table_biggest_spend <- HTML(
  "<b>Largest Transactions Table</b><br><br>
  A simple table showing the biggest transactions in the selected month."
)

intro_B_table_most_frequent_spend <- HTML(
  "<b>Most Frequent Transactions Table</b><br><br>
  A simple table showing the most frequent transactions in the selected month."
)

intro_B_select_B_month <- "Select the month here!"


# Tab C ----
intro_C_plot_earnings_over_time <- HTML(
  "<b>Earnings and Deductions Chart</b><br><br>
  See how much you pay in various deductions (also as percentages)!
  Gross monthly earnings for financial years 2022/23 and 2023/24
  are the median salaries in England in respective years."
)

intro_C_plot_liabilities <- HTML(
  "<b>Liabilities Charts</b><br><br>
  You don't have any student loans? Well, lucky you! Most of the UK's students
  do, and these loans like to skyrocket alongside high interest rates...
  You can see various charts related to such liabilities.<br><br> In the
  <a href='https://github.com/Admate8/appPersonal/blob/main/data-raw/student_loan_letters.R' target='_blank'>
  source code</a>, I also included a script allowing you to scrape
  this data from your annual SLC letters (in PDF) - you're welcome :)"
)

intro_C_table_earnings_check <- HTML(
  "<b>Monthly Earnings Checks</b><br><br>
  Do you trust your monthly payslips? I don't. That's why this table checks
  them for me - are deductions within a reasonable range from where you expect
  them to be or should the net earnings be different?"
)

intro_C_income_simulation_card <- HTML(
  "<b>Income Simulation Tool</b><br><br>
  That is one of my favourite features. How much would your net income change
  if your gross income changed? How much would you pay, e.g. tax? What if
  the government changes tax allowance? What if you get a 5% raise? <br><br>
  Model all such scenarios here by setting up your annual gross income and
  various settings and choose to show the results either yearly,
  monthly or weekly. The table is a single slice of the plot below - both are
  reactive to the settings changes."
)

intro_C_alowances_settings <- "Simulation settings are here!"

intro_C_plot_deductions_calculator <- "Just look at how much we pay in deductions as our income increases!"

intro_C_deductions_links <- "Some handy links to the sources!"


# Tab D ----
intro_D_plot_cal_macros <- HTML(
  "<b>You Are What You Eat</b><br><br>
  (Bias warning: I love this graph!) Track your calories, macros and nutrient
  intake over time to better understand your eating habits. Cutting down on
  sugar consumption proves difficult regardless...  <br><br> The cards on the
  right-hand side show the averages over the selected month."
)


# Tab E ----
intro_E_table_measurements <- HTML(
  "<b>Measure to Progress</b><br><br>
  Track your weekly body measurements across time to be able to set realistic
  fitness goals! For more visual-preferring folks like me, the sparkline series
  show the change more graphically."
)

intro_E_exercises_gym_targets <- HTML(
  "<b>Aim High!</b><br><br>
  General performance cards keep you on track to achieve your goals."
)

intro_E_exercises_rating_calendar <- HTML(
  "<b>Activities Rating Over Time</b><br><br>
  Show what each activity felt like over time. <br><br>
  (However funny this might appear, this chart fights my laziness -
  I hate to see those light-pink squares popping up and ruining the ideal
  shade of green, so I make sure I don't skip any activities! If something
  is silly but works, it is not silly!)"
)

intro_E_exercises_over_time <- HTML(
  "<b>Exercises Load Progression</b><br><br>
  Lift those weights! Use the timeline to change exercises."
)

intro_E_gym_sessions_over_time <- HTML(
  "<b>Repetition is Key!</b><br><br>
  Track which exercises were done and when to stick to your fitness plans.
  This chart automatically shows the latest five months of data."
)


# Tab F ----
intro_F_page_overview <- HTML(
  "<b>Set of Issues to Tackle</b><br><br>
  The main questions that this page tries to address are <em>how to prioritise
  which area of improvement to focus on</em> and <em>does improving one area
  improve the other? If so, by how much?</em> It aims to quantify the impact
  of each issue on either personal, professional or interpersonal life.
  Of course, the issues, their importance and their impact on relationships
  are highly subjective, but it helps to have something tangible before one
  can form an action plan (or at least it helps me!). So let's have a closer look."
)

intro_F_table_pdev <- HTML(
  "<b>Issues and Their Importance</b><br><br>
  Categorise issues and assign their importance.
  After closing the guidance, hover over the table column headers for more info.
  Tick the circles in the first column to filter the network chart and
  relationships table, and show a potential solution in the panel below."
)

intro_F_network_pdev <- HTML(
  "<b>Issues Network</b><br><br>
  This network is a lovely way of visualising how issues are related.
  Hover over the nodes and edges for more details."
)

intro_F_text_solution_pdev <- HTML(
  "Potential solution to the issue selected in the table above will show here."
)

intro_F_table_pdev_relationships <- HTML(
  "Dependent relationships to the one selected in the table will be shown here."
)

intro_F_page_overview_2 <- HTML(
  "<b>Issues Progress</b><br><br>
  Log reflections related to the issues and show them in the Gantt chart.
  Use the selector above to display desirable categories and download a single
  log (appears after selecting a log) or the entire set of logs as PDFs."
)


intro_final <- HTML(
  "<b>Thank you!</b><br><br>
  Did you like this dashboard? Get in touch! :)"
)
