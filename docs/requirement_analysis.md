# Medical Appointment Scheduler

## Overview

The Medical Appointment Scheduler is a comprehensive web application designed to streamline the scheduling and
management of appointments between doctors and patients. With a focus on user authentication, profile management,
appointment booking, and administrative control, the application aims to enhance the overall experience for both
healthcare providers and patients.

## Features

1. **User Authentication:**
    - Patients, doctors, and administrators should be able to register and log in to the system securely.
    - Password recovery/reset functionality should be available.

2. **Doctor Profiles:**
    - Doctors should be able to create and manage their profiles.
    - Each doctor profile should include details such as name, specialty, contact information, working hours, and
      clinic/hospital address.

3. **Patient Profiles:**
    - Patients should be able to create and manage their profiles.
    - Each patient profile should include details such as name, contact information, and medical history (optional).

4. **Admin Dashboard:**
    - Administrators should have access to a dashboard for managing users, appointments, and system settings.
    - Admins should be able to view reports and analytics related to appointments and user activity.

5. **Doctors Hub:**
    - Patients should be able to view a list of all doctors registered on the platform.
    - Patients should be able to search for doctors based on specialty, location, or availability.

6. **Appointment Booking:**
    - Patients should be able to view available appointment slots for different doctors.
    - Patients should be able to book appointments with their preferred doctors based on availability.
    - Doctors should be able to approve or reject appointment requests from patients.

7. **Appointment View:**
    - Doctors, patients, and administrators should be able to view appropriate appointments.

8. **Appointment Management:**
    - Doctors should be able to reschedule or cancel appointments as needed.
    - Patients should be able to reschedule or cancel appointments they've booked.

9. **Notifications:**
    - Doctors and patients should receive email notifications for appointment confirmations, rescheduling, and
      cancellations.

10. **Reviews and Ratings:**
    - Patients should be able to leave reviews and ratings for doctors based on their experience.
    - Doctors should be able to view and respond to patient reviews.

## Technology Stack

- **Frontend:** HTML, Tailwind CSS, JavaScript (with ERB templates)
- **Backend:** Ruby on Rails
- **Database:** SQLite (for development), PostgreSQL (for production)
- **Authentication:** JWT (JSON Web Tokens), OAuth (for social login) [optional]
- **Notification:** SendGrid (for email) [optional]

## Additional Considerations

- The application should be responsive and accessible, supporting multiple devices and screen sizes.
- Data privacy and security should be ensured, with measures in place to protect sensitive patient information.

## Future Enhancements

- Telemedicine and prescription integration for virtual appointments.
- Live messaging system between doctors and patients.
- Same user can obtain multiple roles (e.g., patient and doctor) and switch between them.
