require 'rails_helper'

RSpec.describe "agarose_gels/edit", type: :view do
  before(:each) do
    @agarose_gel = assign(:agarose_gel, AgaroseGel.create!(
      :percent_agarose => "MyString",
      :voltage => "MyString",
      :notes => "MyText",
      :user => nil
    ))
  end

  it "renders the edit agarose_gel form" do
    render

    assert_select "form[action=?][method=?]", agarose_gel_path(@agarose_gel), "post" do

      assert_select "input#agarose_gel_percent_agarose[name=?]", "agarose_gel[percent_agarose]"

      assert_select "input#agarose_gel_voltage[name=?]", "agarose_gel[voltage]"

      assert_select "textarea#agarose_gel_notes[name=?]", "agarose_gel[notes]"

      assert_select "input#agarose_gel_user_id[name=?]", "agarose_gel[user_id]"
    end
  end
end
