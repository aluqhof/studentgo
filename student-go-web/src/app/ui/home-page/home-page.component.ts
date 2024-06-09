import { Component } from '@angular/core';
import { CityResponse } from '../../models/city-response.interface';
import { CityService } from '../../services/city.service';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrl: './home-page.component.css'
})
export class HomePageComponent {


  imageUrl: string | null = null;
  cities: CityResponse[] = [];
  citiesWithPhotos: Array<{ id: number, name: string, photoUrl: string }> = [];
  isModalOpen: boolean = false;

  constructor(private cityService: CityService) { }

  ngOnInit(): void {
    this.getAllCities();
  }

  openModal() {
    this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;
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
