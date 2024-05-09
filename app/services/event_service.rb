# frozen_string_literal: true

require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class EventService
  APPLICATION_NAME = 'Google Calendar Event Service'
  CREDENTIALS_PATH = 'credentials-gsuite.json'
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
  CALENDER_ID = 'c_decd7907534c4a889dacb758a4f66520b2c1493ff7042278ee717896635d8945@group.calendar.google.com'

  attr_accessor :calender_service

  def initialize
    self.calender_service = Google::Apis::CalendarV3::CalendarService.new
    calender_service.client_options.application_name = APPLICATION_NAME
    calender_service.authorization = authorize
  end

  def share_calendar_with_attendees(appointment)
    patient_rule = create_rule(appointment.patient)
    doctor_rule = create_rule(appointment.doctor)
    calender_service.insert_acl(CALENDER_ID, patient_rule)
    calender_service.insert_acl(CALENDER_ID, doctor_rule)
  end

  def create_event(appointment)
    event = Google::Apis::CalendarV3::Event.new(
      summary: appointment.title,
      start: {
        date_time: appointment.scheduled_time.rfc3339
      },
      end: {
        date_time: appointment.end_time.rfc3339
      }
    )

    calender_service.insert_event(CALENDER_ID, event)
  end

  def update_event(appointment)
    event = event_by(appointment.event_id)
    event.start.date_time = appointment.scheduled_time.rfc3339
    event.end.date_time = appointment.end_time.rfc3339

    calender_service.update_event(CALENDER_ID, event.id, event)
  end

  def calendar_link
    "https://calendar.google.com/calendar/r?cid=#{CALENDER_ID}"
  end

  def calendar_id
    CALENDER_ID
  end

  private

  def attendees(appointment)
    attendees = []

    attendees << Google::Apis::CalendarV3::EventAttendee.new(
      email: appointment.doctor.email,
      response_status: 'accepted'
    )
    attendees << Google::Apis::CalendarV3::EventAttendee.new(
      email: appointment.patient.email,
      response_status: 'accepted'
    )
    attendees
  end

  def create_rule(user, role = 'reader', type = 'user')
    Google::Apis::CalendarV3::AclRule.new(
      role:,
      scope: {
        type:,
        value: user.email
      }
    )
  end

  def event_by(event_id)
    calender_service.get_event(CALENDER_ID, event_id)
  end

  def authorize
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CREDENTIALS_PATH),
      scope: SCOPE
    )
  end
end
