import { Component, EventEmitter, Input, Output } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { TokenStorageService } from '../../services/token-storage.service';

@Component({
  selector: 'app-modal-login',
  templateUrl: './modal-login.component.html',
  styleUrl: './modal-login.component.css'
})
export class ModalLoginComponent {

  @Input() isModalOpen!: boolean;
  @Output() modalClosed = new EventEmitter<void>();
  form: any = {
    username: null,
    password: null
  };
  isLoggedIn = false;
  isLoginFailed = false;
  errorMessage = '';
  role!: string;
  username!: string;

  constructor(private router: Router, private authService: AuthService,
    private tokenStorage: TokenStorageService
  ) { }

  ngOnInit() {
  }

  closeModal() {
    this.isModalOpen = false;
    this.modalClosed.emit();
  }

  openModal() {
    this.isModalOpen = true;
  }

  onSubmit(): void {
    const { username, password } = this.form;
    console.log(username + " " + password)

    this.authService.login(username, password).subscribe({
      next: data => {
        //this.tokenStorage.saveToken(data.accessToken);
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
        console.log(err);
      }
    });
  }

  reloadPage(): void {
    window.location.reload();
  }
}
