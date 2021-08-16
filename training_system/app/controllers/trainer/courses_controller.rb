class Trainer::CoursesController < Trainer::BaseController
  before_action :load_course, only: [:show, :edit, :update, :start_course]
  before_action :load_course_start, :load_for_start_subject, only: :start_subject
  before_action :trainee_not_course, only: :edit

  def index
    @courses = Course.created_desc.page(params[:page])
                     .per(Settings.courses.per_page)
  end

  def show
    load_trainers @course
    load_trainees @course
    load_subjects @course
  end

  def edit
    load_trainees @course
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params

    if @course.save
      flash[:success] = t "courses.create.success"
      redirect_to trainer_courses_path
    else
      render :new
    end
  end

  def update
    if @course.update course_params
      flash[:success] = t "courses.update.success"
      redirect_to trainer_course_path
    else
      flash.now[:danger] = t "courses.update.failed"
      render :edit
    end
  end

  def start_course
    begin
      @course.in_progress!
      flash[:success] = t "courses.update.success"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "courses.update.failed"
    ensure
      redirect_to trainer_courses_path
    end
  end

  def start_subject
    ActiveRecord::Base.transaction do
      @course_users.each do |course_user|
        @course_start_subject.user_course_subjects
                              .build(user_course_id: course_user.id)
      end
      @course_start_subject.save!
      @course_start_subject.in_progress!
      @course_start_subject.update!(start_date: Time.zone.now.to_date)
      flash[:success] = t "courses.update.success"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "courses.update.failed"
    ensure
      redirect_to trainer_course_path @course.id
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :name, :description, :status, :start_date, :end_date,
      subject_ids: [], user_ids: []
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

  def trainee_not_course
    trainees = @course.users.trainee.ids
    @trainees_not_course = User.trainee.user_not_course(trainees)
                               .page(params[:page])
                               .per(Settings.courses.per_page)
  end

  def load_course_start
    @course = Course.find_by id: params[:course_id]
    return if @course

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainer_courses_path
  end

  def load_for_start_subject
    @course_users = @course.user_courses
    @course_start_subject = @course.course_subjects
                                   .find_by subject_id: params[:subject_id]
    if @course_start_subject.blank?
      flash[:danger] = t("controllers.course_controller.error_show")
      redirect_to trainer_courses_path
    end
  end
end
