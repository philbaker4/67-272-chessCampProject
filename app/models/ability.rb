class Ability
  include CanCan::Ability

  def initialize(user)


    user ||= User.new


      if user.role? :admin
        can :manage, :all
      elsif user.role? :instructor
        can :read, Location
        can :read, Camp
        can :read, Curriculum

        # manage their own profile info
        can :show, User, id: user.id
        can :update, User, id: user.id
        can :update, Instructor, user_id: user.id
        can :show, Instructor, user_id: user.id



        can :show, Student do |s|
          Instructor.find_by_user_id(user.id).camps.map{|c| c.students}.flatten.include? s
        end

        can :show, Family do |f|
          stud = Instructor.find_by_user_id(user.id).camps.map{|c| c.students}.flatten
          stud.map{|s| s.family_id}.include? f.id
        end


      elsif user.role? :parent

        can :read, Curriculum 

        can :read, Camp
        # manage their own profile info
        can :show, User, id: user.id
        can :update, User, id: user.id # bad line. janky fix in object options 
        can :update, Family, user_id: user.id
        can :show, Family, user_id: user.id
         

        can :manage, Student do |s|
          Family.find_by_user_id(user.id).students.map{|stud| stud.id}.include? s.id
        end
        cannot :index, Student


        # create camp registrations
        can :create, Registration do |reg|
          Family.find_by_user_id(user.id).students.map{|stud| stud}.include?(Student.find(reg.student_id))
        end

        can :add_to_cart, Camp
        can :delete_from_cart, Camp

      else

        can :read, Camp
        can :read, Curriculum
        can :manage, User
        can :manage, Family
        cannot :index, User
        cannot :index, Family
        cannot :show, User
        cannot :show, Family
        cannot :edit, User
        cannot :edit, Family
        cannot :update, User
        cannot :update, Family
        cannot :destroy, User
        cannot :destroy, Family



      end
  end
end
