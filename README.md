Philip Baker 
Carnegie Mellon Information Systems 2019 
67-272 Application Design and Development Spring 2018
Professor Larry Heimann 


67-272 is a semester long project course where students dive into the process and learn principles of application design and development. In the course, students are given a narrative and must work through the process to create a ruby on rails application. This project's narrative centered around two people, Alex and Mark, that wanted to create a business that offers chess camps throughout the year. This is the final deliverable for the project. 

Technologies used: 
  - Ruby 2.4
  - Rails 5.1
  - Vue.js 2.5
  - HTML5
  - CSS3
  - Materialize.css
  - Jquery
  - lazy_high_charts gem
  - sqlite

Steps to set up and run project:
  - bundle install 
  - rails db:populate (must ensure that all dates are in the future in lib/tasks/populate.rake and that all end dates are after start dates)
  - rails server

Login Information:
  Admin:
    mheimann@razingrooks.com
    secret
  Instructor:
    sarah@razingrooks.com
    secret



Notes:

Admin Dashboard:
  - Currently, our system is operating under the assumption that when parents register for camps, they pay for all registrations in full. Assuming that in the future we will allow parents to place a downpayment to hold a spot in a camp, the unpaid registrations table on the admin dashboard will be populated. 
  - A table of families that have been created in the last week has been created so that the admin will be better prepared to send welcome emails/newsletters for the new families.
  - A pie chart of the average ranking of students has been created so that the admins can tell which level of camps they need to offer more of 