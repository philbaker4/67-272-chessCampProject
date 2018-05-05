class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new

      if user.role? :admin
        can :manage, :all
      elsif user.role? :instructor
        can :read, Location
        can :read, Camp
        can :read, Curriculum
        students = []

        # read student info if they have taught them before
        can :show, Student do |s|
          students = []
          Instructor.find_by_user_id(user.id).camps.each do |c|
              c.students.each do |stud|
                students << stud
              end
          end      
          students.include?s
        end

        # read family info if they have taught a student from that family before
        can :show, Family do |f|
          families = []
          Instructor.find_by_user_id(user.id).camps.each do |c|
              c.students.each do |s|
                families << s.family_id
              end
          end     
          families.include?f.id 
        end

        # manage their own profile info
        can :read, User do |u|  
          u.id == user.id
        end

      # manage their own profile info
        can :read, Instructor do |i|  
          i.id == Instructor.find_by_user_id(user.id).id
        end

        # they can update their own user profile
        can :update, User do |u|  
          u.id == user.id
        end

        # update own instructor profile
        can :update, Instructor do |i|  
          i.id == Instructor.find_by_user_id(user.id).id
        end


 


        # photo ????  

      elsif user.role? :parent
        can :read, Camp
        can :read, Curriculum

        # manage their own profile info
        can :read, User do |u|  
          u.id == user.id
        end

        # manage their own profile info
        can :read, Family do |f|  
          f.id == Family.find_by_user_id(user.id).id
        end

        # manage their children
        can :manage, Student do |s|
          Family.find_by_user_id(user.id).id == s.family_id
        end

        # create camp registrations
        can :create, Registration do |reg|
          Family.find_by_user_id(user.id) == reg.s.family
        end

        # edit registrations that arent paid for
        can :update, Registration do |reg|
          reg.payment != nil
        end

        # remove registrations that arent paid for
        can :delete, Registration do |reg|
          reg.payment != nil
        end






      else

        can :manage, :all
      end
  end
end
