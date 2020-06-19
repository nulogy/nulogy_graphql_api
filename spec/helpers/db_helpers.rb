module DbHelpers
  module_function

  def db_connection
    ActiveRecord::Base.connection
  end

  # when you change a table's columns, set force to true to re-generate the table in the DB
  def define_table(table_name, columns, force)
    if table_name_is_free?(table_name) || force
      db_connection.create_table(table_name, force: true) do |t|
        columns.each do |name, type|
          t.send(type, name)
        end
      end
    end
  end

  def define_ar(table_name)
    Class.new(ActiveRecord::Base) do
      self.table_name = table_name
    end
  end

  private

  def table_name_is_free?(table_name)
    !db_connection.data_source_exists?(table_name)
  end
end
