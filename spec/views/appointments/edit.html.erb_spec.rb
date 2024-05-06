require 'rails_helper'

RSpec.describe "appointments/edit", type: :view do
  let(:appointment) {
    Appointment.create!(
      duration_minutes: 1,
      status: 1,
      patient_user: nil,
      doctor_user: nil
    )
  }

  before(:each) do
    assign(:appointment, appointment)
  end

  it "renders the edit appointment form" do
    render

    assert_select "form[action=?][method=?]", appointment_path(appointment), "post" do

      assert_select "input[name=?]", "appointment[duration_minutes]"

      assert_select "input[name=?]", "appointment[status]"

      assert_select "input[name=?]", "appointment[patient_user_id]"

      assert_select "input[name=?]", "appointment[doctor_user_id]"
    end
  end
end
