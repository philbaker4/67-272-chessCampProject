class DashboardsController < ApplicationController

  def show 
    if logged_in? and current_user.role?(:admin)
      
      @camps_this_week = Camp.upcoming.where('start_date <= ? ', date_of_next("Monday")).chronological.paginate(:page => params[:page], :per_page => 5)

      @unpaid_registrations = Registration.joins(:camp).where(' ? <= start_date and payment is NULL', Date.today).paginate(:page => params[:page]).per_page(7)

      @new_families = Family.all.where("created_at  > ?", 2.weeks.ago.to_date).order('created_at')
      @new_families_paginated = @new_families.paginate(:page => params[:page], :per_page => 5)


      zero = Student.active.at_or_above_rating(0).below_rating(1).count
      count_of_1_to_5 = Student.active.at_or_above_rating(100).below_rating(500).count
      count_of_5_to_10 = Student.active.at_or_above_rating(500).below_rating(1000).count
      count_of_10_to_15 = Student.active.at_or_above_rating(1000).below_rating(1500).count
      count_of_15_to_20 = Student.active.at_or_above_rating(1500).below_rating(2000).count
      count_of_20_to_25 = Student.active.at_or_above_rating(2000).below_rating(2500).count
      count_of_25_to_30 = Student.active.at_or_above_rating(2500).below_rating(3001).count
      


      data = [{name: "0", y: zero},{name: "100-500", y: count_of_1_to_5},{name: "500-1000", y: count_of_5_to_10},{name: "1000-1500", y: count_of_10_to_15},{name: "1500-2000", y: count_of_15_to_20},{name: "2000-2500", y: count_of_20_to_25},{name: "2500-3000", y: count_of_25_to_30}]
      @chart = LazyHighCharts::HighChart.new('pie') do |f|
        f.title(text: "Student Rankings by Range")
        f.series({name: "Rankings", data: data})
        
        f.tooltip( {
        pointFormat: '{series.name}: <b>{point.y}</b>   |   <b>{point.percentage:.1f}%</b> '
      })
        f.plotOptions( {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true

            }
          }
      })

        

        f.chart({defaultSeriesType: "pie"})
      end

      @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
        f.global(useUTC: false)
        f.chart(
          backgroundColor: {
            stops: [
              [0, "rgb(255, 255, 255)"]            ]
          },
          plotBackgroundColor: "rgba(255,255,255, .9)",
          plotShadow: true,
        )
        f.lang(thousandsSep: ",")
        f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
      end





    elsif logged_in? and current_user.role?(:instructor) 
      redirect_to instructor_path(Instructor.find_by_user_id(current_user.id))





    elsif logged_in? and current_user.role?(:parent)

      @family = Family.find_by_user_id(current_user.id)
      @students = @family.students.alphabetical
      upc_reg = []
      @students.each do |s|
        s.camps.upcoming.chronological.each do |c|
          upc_reg << [c, s]
        end
      end


      @upcoming_reg = upc_reg.paginate(:page => params[:page], :per_page => 10)

      students = @family.students.alphabetical.map { |s| s.first_name  }
      total_students = Student.active.size.to_f
      percentiles = []
      rank_percentile = @family.students.alphabetical.each do |s|

      percentiles << Student.active.below_rating(s.rating).size / total_students * 100
      end

      @chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "Rating Percentiles ")
        f.xAxis(categories: students)
        f.series(name: "Percentile", yAxis: 0, data: percentiles)


        f.chart({defaultSeriesType: "column"})
      end

      @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
        f.global(useUTC: false)
        f.chart(
          
          plotBackgroundColor: "rgba(255, 255, 255, .9)",
          plotShadow: true,
          plotBorderWidth: 1
        )
        f.lang(thousandsSep: ",")
        f.colors(["#ff1744"])
      end

    else
      redirect_to home_path
    end



  end

  def date_of_next(day)
        date  = Date.parse(day)
        delta = date > Date.today ? 0 : 7
        date + delta
      end


  
end 