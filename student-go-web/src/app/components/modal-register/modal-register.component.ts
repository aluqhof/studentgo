import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { TokenStorageService } from '../../services/token-storage.service';
import { EventTypeService } from '../../services/event-type.service';
import { EventTypeResponse } from '../../models/event-type-response.inteface';

@Component({
  selector: 'app-modal-register',
  templateUrl: './modal-register.component.html',
  styleUrl: './modal-register.component.css'
})
export class ModalRegisterComponent {

  @Input() isModalOpen!: boolean;
  @Output() modalClosed = new EventEmitter<void>();
  form = {
    username: '',
    password: '',
    verifyPassword: '',
    email: '',
    name: '',
    interests: [],
  };
  isLoggedIn = false;
  isLoginFailed = false;
  errorMessage = '';
  role!: string;
  username!: string;
  eventTypes!: EventTypeResponse[];
  selectedEt: EventTypeResponse[] = [];
  fieldErrors: { [key: string]: string } = {};

  constructor(private router: Router, private authService: AuthService,
    private tokenStorage: TokenStorageService, private eventTypeService: EventTypeService
  ) { }

  ngOnInit() {
    this.getAllEventTypes()
  }

  closeModal() {
    this.isModalOpen = false;
    this.modalClosed.emit();
  }

  openModal() {
    this.isModalOpen = true;
  }

  addInterest(event: any) {
    const selectedEventType = JSON.parse(event.target.value);
    if (selectedEventType) {
      this.selectedEt.push(selectedEventType);
      this.eventTypes = this.eventTypes.filter(item => item.id !== selectedEventType.id);
    }
  }

  removeInterest(selectedEventType: EventTypeResponse) {
    if (selectedEventType) {
      this.eventTypes.push(selectedEventType);
      this.selectedEt = this.selectedEt.filter(item => item.id !== selectedEventType.id);
    }
  }

  getAllEventTypes() {
    this.eventTypeService.getEventTypes().subscribe({
      next: (data) => {
        this.eventTypes = data;
      },
      error: (error) => {
        console.error('Error getting event types:', error);
      }
    });
  }

  onSubmit(): void {
    const { username, password } = this.form;
    this.authService.registerUser({
      username: this.form.username,
      password: this.form.password,
      verifyPassword: this.form.verifyPassword,
      email: this.form.email,
      name: this.form.name,
      interests: this.selectedEt.map(et => et.id),
    }).subscribe({
      next: data => {
        this.tokenStorage.saveToken(data.token);
        this.tokenStorage.saveUser(data);
        localStorage.setItem("USER_ID", data.id)

        this.isLoginFailed = false;
        this.isLoggedIn = true;
        this.role = data.role;
        this.username = data.username;
        this.closeModal();
        this.reloadPage();
      },
      error: err => {
        this.errorMessage = err.error.detail;
        this.isLoginFailed = true;
        if (err.status === 400) {
          if (err.error && err.error["Fields errors"]) {
            this.fieldErrors = {};
            err.error["Fields errors"].forEach((fieldError: any) => {
              if (!this.fieldErrors[fieldError.field] && fieldError.message.includes("The passwords do not match")) {
                this.fieldErrors['passwordDontMatch'] = fieldError.message
              }
              this.fieldErrors[fieldError.field] = fieldError.message;
            });
          }
        }
        return false;
      }
    });
  }

  reloadPage(): void {
    window.location.reload();
  }
}
