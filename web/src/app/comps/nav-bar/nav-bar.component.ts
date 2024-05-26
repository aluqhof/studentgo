import { Component } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { CitySearchModalComponent } from '../city-search-modal/city-search-modal.component';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrl: './nav-bar.component.css'
})
export class NavBarComponent {
  constructor(private modalService: NgbModal, public authService: AuthService, private router: Router) { }

  openModal() {
    const modalRef = this.modalService.open(CitySearchModalComponent,);
    modalRef.result.then((selectedCity) => {
      console.log('City selected:', selectedCity);
    }, () => {
      console.log('Modal dismissed without selection');
    });
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/home']);
  }
}
