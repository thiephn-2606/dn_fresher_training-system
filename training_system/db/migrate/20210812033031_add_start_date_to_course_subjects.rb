class AddStartDateToCourseSubjects < ActiveRecord::Migration[6.1]
  def change
    add_column :course_subjects, :start_date, :date
  end
end
