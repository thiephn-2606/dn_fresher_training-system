class Trainer::CoursesController < Trainer::BaseController
  before_action :load_course, only: :show

  before_action :load_course_params, 
                :params_user_course,
                :params_course_subject,
                only: :create

  def index
    @courses = Course.created_desc.page(params[:page])
                     .per(Settings.courses.per_page)
  end

  def show
    load_trainers @course
    load_trainees @course
    load_subjects @course
  end

  def new
    @course = Course.new
    @course.user_courses.build
    @course.course_subjects.build
  end

  def create
    if @course.save
      @user_id.each do |user|
        @course.user_courses.build(user_id: @user_id[@start_count_course]).save
      end

      @subject_id.each do |sb|
        @course.course_subjects.build(subject_id: @subject_id[@start_count_sb]).save
      end
      flash[:success] = t "courses.create.success"
      redirect_to trainer_courses_path
    else
      render :new
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :name, :description, :status, :start_date, :end_date,
      user_courses_attributes: [user_id: []],
      course_subjects_attributes: [subject_id: []]
    )
  end

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainer_courses_path
  end

  def load_trainers course
    @trainers = course.users.trainer.page(params[:page])
                      .per(Settings.courses.per_page)
  end

  def load_trainees course
    @trainees = course.users.trainee.page(params[:page])
                      .per(Settings.courses.per_page)
  end

  def load_subjects course
    @subjects = course.subjects.page(params[:page])
                      .per(Settings.courses.per_page)
  end

  def params_user_course
    @start_count_course = 1
    @user_id = params[:course][:user_courses_attributes]["0"][:user_id]
    @course.user_courses.each do |m|
      m.user_id = @user_id[@start_count_course]
      @start_count_course += 1
    end
  end
  
  def params_course_subject
    @start_count_sb = 1

    @subject_id = params[:course][:course_subjects_attributes]["0"][:subject_id]
    @course.course_subjects.each do |m|
      m.subject_id = @subject_id[@start_count_sb]
      @start_count_sb += 1
    end
  end

  def load_course_params
    @course = Course.new course_params
  end
end
