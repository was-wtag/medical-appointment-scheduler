import { Controller } from "@hotwired/stimulus"

const ROLE_PATIENT = 'patient';
const ROLE_DOCTOR = 'doctor';

export default class extends Controller {
  static targets = [ 'role', 'patient', 'doctor' ];

  initialize() {
    console.log('Role controller initialized');
    this.toggleFields();
  }

  toggleFields() {
    console.log("Role changed to: ", this.roleTarget.value);
    console.log("Toggling fields...");

    const { roleTarget, patientTarget, doctorTarget } = this;
    const role = roleTarget.value;

    switch(role) {
      case ROLE_PATIENT:
        this.toggleDisplay(patientTarget, doctorTarget);
        break;
      case ROLE_DOCTOR:
        this.toggleDisplay(doctorTarget, patientTarget);
        break;
    }
  }

  toggleDisplay(showTarget, hideTarget) {
    showTarget.style.display = 'block';
    hideTarget.style.display = 'none';
  }
}
