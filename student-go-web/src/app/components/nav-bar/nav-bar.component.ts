import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { CityService } from '../../services/city.service';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrl: './nav-bar.component.css'
})
export class NavBarComponent {

  openCityModal: boolean = false;
  isModalLoginOpen: boolean = false;
  isModalRegisterOpen: boolean = false;

  constructor(public authService: AuthService, private router: Router, private cityService: CityService) { }

  openModal() {
    this.isModalLoginOpen = false;
    this.isModalRegisterOpen = false;
    this.openCityModal = true;
  }

  openModalLogin() {
    this.isModalLoginOpen = true;
    this.isModalRegisterOpen = false;
    this.openCityModal = false;
  }

  openModalRegister() {
    this.isModalLoginOpen = false;
    this.isModalRegisterOpen = true;
    this.openCityModal = false;
  }

  closeModal() {
    this.openCityModal = false;
  }

  closeModalLogin() {
    this.isModalLoginOpen = false;
  }

  closeModalRegister() {
    this.isModalRegisterOpen = false;
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/home']);
  }
}
