require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  before(:each) do
    assign(:appointments, [
      Appointment.create!(
        duration_minutes: 2,
        status: 3,
        patient_user: nil,
        doctor_user: nil
      ),
      Appointment.create!(
        duration_minutes: 2,
        status: 3,
        patient_user: nil,
        doctor_user: nil
      )
    ])
  end

  it "renders a list of appointments" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
