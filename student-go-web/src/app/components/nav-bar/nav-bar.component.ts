import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { CityResponse } from '../../models/city-response.interface';
import { CityService } from '../../services/city.service';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrl: './nav-bar.component.css'
})
export class NavBarComponent {

  openCityModal: boolean = false;
  isModalLoginOpen: boolean = false;

  constructor(public authService: AuthService, private router: Router, private cityService: CityService) { }

  openModal() {
    this.isModalLoginOpen = false
    this.openCityModal = true;
  }

  openModalLogin() {
    this.isModalLoginOpen = true
    this.openCityModal = false;
  }

  closeModal() {
    this.openCityModal = false;
  }

  closeModalLogin() {
    this.isModalLoginOpen = false;
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/home']);
  }
}
