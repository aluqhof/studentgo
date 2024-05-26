import { Component } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { CitySearchModalComponent } from '../../comps/city-search-modal/city-search-modal.component';
import { CityService } from '../../services/city.service';
import { CityResponse } from '../../models/city-response.interface';
import { Observable, forkJoin, map } from 'rxjs';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrl: './home-page.component.css',
})
export class HomePageComponent {

  constructor(private modalService: NgbModal, private cityService: CityService) { }

  imageUrl: string | null = null;
  cities: CityResponse[] = [];
  citiesWithPhotos: Array<{ id: number, name: string, photoUrl: string }> = [];

  ngOnInit(): void {
    this.getAllCities();
  }


  openModal() {
    const modalRef = this.modalService.open(CitySearchModalComponent,);
    modalRef.result.then((selectedCity) => {
      console.log('City selected:', selectedCity);
    }, (reason) => {
      console.log('Modal dismissed without selection');
    });
  }

  getAllCities() {
    this.cityService.getCities().subscribe({
      next: (data) => {
        this.cities = data;
      },
      error: (error) => {
        console.error('Error getting cities:', error);
      }
    });
  }

}
