require 'rails_helper'

RSpec.describe "appointments/new", type: :view do
  before(:each) do
    assign(:appointment, Appointment.new(
      duration_minutes: 1,
      status: 1,
      patient_user: nil,
      doctor_user: nil
    ))
  end

  it "renders new appointment form" do
    render

    assert_select "form[action=?][method=?]", appointments_path, "post" do

      assert_select "input[name=?]", "appointment[duration_minutes]"

      assert_select "input[name=?]", "appointment[status]"

      assert_select "input[name=?]", "appointment[patient_user_id]"

      assert_select "input[name=?]", "appointment[doctor_user_id]"
    end
  end
end
