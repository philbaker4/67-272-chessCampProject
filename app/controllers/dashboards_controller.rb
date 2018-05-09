class DashboardsController < ApplicationController

  def show 
    if logged_in? and current_user.role?(:admin)
      
      @camps_this_week = Camp.upcoming.where('start_date <= ? ', date_of_next("Monday")).chronological.paginate(:page => params[:page], :per_page => 5)

      @unpaid_registrations = Registration.joins(:camp).where(' ? <= start_date and payment is NULL', Date.today).paginate(:page => params[:page]).per_page(7)

      @new_families = Family.all.where("created_at  > ?", 2.weeks.ago.to_date).order('created_at')
      @new_families_paginated = @new_families.paginate(:page => params[:page], :per_page => 5)


      a = [1,2,3,4,5]
      @chart = LazyHighCharts::HighChart.new('line') do |f|
        f.title(text: "Profit vs New Families")
        f.xAxis(categories: ["United States", "Japan", "China", "Germany", "France"])
        f.series(name: "GDP in Billions", yAxis: 0, data: a)
        f.series(name: "Population in Millions", yAxis: 1, data: [310, 127, 1340, 81, 65])

        f.yAxis [
          {title: {text: "GDP in Billions", margin: 70} },
          {title: {text: "Population in Millions"}, opposite: true},
        ]

        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "line"})
      end

      @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
        f.global(useUTC: false)
        f.chart(
          backgroundColor: {
            stops: [
              [0, "rgb(255, 255, 255)"],
              [1, "rgb(240, 240, 255)"]
            ]
          },
          plotBackgroundColor: "rgba(255,255,255, .9)",
          plotShadow: true,
          plotBorderWidth: 1
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
    # parent stuff 
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