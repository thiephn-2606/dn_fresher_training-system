class CreateUserTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tasks do |t|
      t.references :user_course_subject, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
