# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # devise
      t.database_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable

      # user
      t.string :first_name, :limit => 80
      t.string :last_name, :limit => 80
      t.string :phone, :limit => 20
      t.string :mobile, :limit => 20
      t.string :website, :limit => 200
      t.string :account_type, :limit => 15
      t.string :description, :limit => 255

      t.boolean :change_default_password, :default => false
      t.string :address

      t.timestamps
    end
    add_index :users, :first_name
    add_index :users, :last_name

  end

end
