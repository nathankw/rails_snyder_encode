require 'rails_helper'

RSpec.describe "data_storages/new", type: :view do
  before(:each) do
    assign(:data_storage, DataStorage.new(
      :user => nil,
      :name => "MyString",
      :bucket => "MyString",
      :project_identifier => "MyString",
      :folder_base_path => "MyString"
    ))
  end

  it "renders new data_storage form" do
    render

    assert_select "form[action=?][method=?]", data_storages_path, "post" do

      assert_select "input#data_storage_user_id[name=?]", "data_storage[user_id]"

      assert_select "input#data_storage_name[name=?]", "data_storage[name]"

      assert_select "input#data_storage_bucket[name=?]", "data_storage[bucket]"

      assert_select "input#data_storage_project_identifier[name=?]", "data_storage[project_identifier]"

      assert_select "input#data_storage_folder_base_path[name=?]", "data_storage[folder_base_path]"
    end
  end
end
