import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { TokenStorageService } from '../../services/token-storage.service';

@Component({
  selector: 'app-login-page',
  templateUrl: './login-page.component.html',
  styleUrl: './login-page.component.css'
})
export class LoginPageComponent {
  form: any = {
    username: null,
    password: null
  };
  isLoggedIn = false;
  isLoginFailed = false;
  errorMessage = '';
  role!: string;
  username!: string;

  constructor(private authService: AuthService, private tokenStorage: TokenStorageService, private router: Router) { }

  ngOnInit(): void {
    if (this.tokenStorage.getToken()) {
      this.isLoggedIn = true;
    }
  }

  onSubmit(): void {
    const { username, password } = this.form;

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
        this.router.navigate(['/home']);
      },
      error: err => {
        this.errorMessage = err.error.message;
        this.isLoginFailed = true;
        console.log(err);
      }
    });
  }

  reloadPage(): void {
    window.location.reload();
  }
}
