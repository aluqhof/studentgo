import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Router } from '@angular/router';
import { CityService } from '../../services/city.service';
import { CityResponse } from '../../models/city-response.interface';

@Component({
  selector: 'app-modal-cities',
  templateUrl: './modal-cities.component.html',
  styleUrl: './modal-cities.component.css'
})
export class ModalCitiesComponent {

  @Input() isModalOpen!: boolean;
  @Output() modalClosed = new EventEmitter<void>();
  cities: CityResponse[] = [];
  filteredCities: string[] = [];

  constructor(private router: Router, private cityService: CityService) { }

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

  closeModal() {
    this.isModalOpen = false;
    this.modalClosed.emit();
  }

  openModal() {
    this.isModalOpen = true;
  }

  handleInput(event: Event): void {
    const filterValue = (event.target as HTMLInputElement).value.toLowerCase();
    this.filteredCities = this.cities.map(city => city.name).filter(city =>
      city.toLowerCase().includes(filterValue)
    );
  }

  selectCity(city: string): void {
    this.closeModal();
    this.router.navigate([`/city/${city}`]);
  }
}
