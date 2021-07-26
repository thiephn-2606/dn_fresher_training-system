class CreateUserCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_courses do |t|
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
