import { ChangeDetectorRef, Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { TokenStorageService } from '../../services/token-storage.service';
import { RegisterForm } from '../../models/register-form.interface';
import { EventTypeService } from '../../services/event-type.service';
import { EventTypeResponse } from '../../models/event-type-response.inteface';

@Component({
  selector: 'app-register-page',
  templateUrl: './register-page.component.html',
  styleUrl: './register-page.component.css'
})
export class RegisterPageComponent {

  isSuccessful: boolean = false;
  isSignUpFailed: boolean = false;
  errorMessage: string = '';
  roles: string[] = [];
  isLoggedIn: boolean = false;
  interestList: EventTypeResponse[] = [];
  selectedInterests: EventTypeResponse[] = [];

  form: RegisterForm = {
    username: "",
    password: "",
    verifyPassword: "",
    email: "",
    name: "",
    interests: []
  };

  constructor(private eventTypeService: EventTypeService, private authService: AuthService, private router: Router, private tokenStorage: TokenStorageService) { }

  ngOnInit(): void {
    /*if (this.tokenStorage.getToken()) {
      this.isLoggedIn = true;
      //this.roles = this.tokenStorage.getUser().roles;
      this.roles = ['ROLE_USER'];
    }*/
    this.eventTypeService.getEventTypes().subscribe({
      next: data => {
        this.interestList = data;
      },
      error: err => {
        this.errorMessage = err.error.message;
        console.log(err);
      },
    });
  }


  addInterest(event: any) {
    const selectedInterest = JSON.parse(event.target.value);
    if (selectedInterest) {
      this.selectedInterests.push(selectedInterest);
      this.interestList = this.interestList.filter(item => item.id !== selectedInterest.id);
      console.log(JSON.stringify(this.interestList))
    }
  }

  removeInterest(selectedInterest: EventTypeResponse) {
    if (selectedInterest) {
      this.interestList.push(selectedInterest);
      this.selectedInterests = this.selectedInterests.filter(item => item.id !== selectedInterest.id);
      console.log(JSON.stringify(this.interestList))
    }
  }

  onSubmit() {
    const { password, verifyPassword } = this.form;

    // Validate that the passwords match
    if (password !== verifyPassword) {
      console.log(password)
      console.log(verifyPassword)
      this.errorMessage = 'Passwords do not match';
      this.isSignUpFailed = true;
      return;
    }

    this.form.interests = this.selectedInterests.map(item => item.id);

    this.authService.registerUser(this.form).subscribe({
      next: data => {
        // Handle successful registration
        console.log(data);
        this.isSuccessful = true;
        this.isSignUpFailed = false;

        this.tokenStorage.saveToken(data.token);
        this.tokenStorage.saveUser(data);

        this.roles = ['ROLE_USER'];
        this.router.navigate(['/home']);
      },
      error: err => {
        // Handle registration failure
        this.errorMessage = err.error.message;
        this.isSignUpFailed = true;
        console.log(err);
      },
    });
  }
}
