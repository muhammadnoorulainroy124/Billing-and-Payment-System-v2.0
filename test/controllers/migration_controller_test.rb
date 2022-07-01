require 'test_helper'

class MigrationControllerTest < ActionDispatch::IntegrationTest
  test "should get change_column_null_of_users" do
    get migration_change_column_null_of_users_url
    assert_response :success
  end

end
