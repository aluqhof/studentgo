import { Component } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { CityService } from '../../services/city.service';
import { CityResponse } from '../../models/city-response.interface';

@Component({
  selector: 'app-city-search-modal',
  templateUrl: './city-search-modal.component.html',
  styleUrl: './city-search-modal.component.css'
})
export class CitySearchModalComponent {

  cities: CityResponse[] = [];
  filteredCities: string[] = [];

  constructor(private modalService: NgbModal, private cityService: CityService) {
  }

  ngOnInit() {
    this.getAllCities()
  }

  getAllCities() {
    this.cityService.getCities().subscribe({
      next: (data) => {
        this.cities = data;
        this.filteredCities = this.cities.map(city => city.name);
      },
      error: (error) => {
        console.error('Error getting cities:', error);
      }
    });
  }

  handleInput(event: Event): void {
    const filterValue = (event.target as HTMLInputElement).value.toLowerCase();
    this.filteredCities = this.cities.map(city => city.name).filter(city =>
      city.toLowerCase().includes(filterValue)
    );
  }

  selectCity(city: string): void {
    this.modalService.dismissAll(city);  // Cierra el modal y pasa la ciudad seleccionada
  }

  closeModal(): void {
    this.modalService.dismissAll();  // Cierra el modal sin seleccionar una ciudad
  }
}
