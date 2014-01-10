require 'spec_helper'

describe "events/edit" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :title => "MyString",
      :content => "MyString",
      :latitude => 1.5,
      :longitude => 1.5,
      :user_id => 1
    ))
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => events_path(@event), :method => "post" do
      assert_select "input#event_title", :name => "event[title]"
      assert_select "input#event_content", :name => "event[content]"
      assert_select "input#event_latitude", :name => "event[latitude]"
      assert_select "input#event_longitude", :name => "event[longitude]"
      assert_select "input#event_user_id", :name => "event[user_id]"
    end
  end
end
