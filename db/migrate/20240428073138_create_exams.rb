class CreateExams < ActiveRecord::Migration[7.1]
  def change
    create_table :exams do |t|
      t.string :exam_id, null: false
      t.string :name, null: false
      t.string :status, null: false, default: "activated"
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: false
      t.timestamps
    end

    add_index :exams, :exam_id, unique: true
  end
end
