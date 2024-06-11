import { Component } from '@angular/core';
import { CityResponse } from '../../models/city-response.interface';
import { CityService } from '../../services/city.service';

@Component({
  selector: 'app-admin-cities',
  templateUrl: './admin-cities.component.html',
  styleUrl: './admin-cities.component.css'
})
export class AdminCitiesComponent {

  cityList: CityResponse[] = [];
  openModal: boolean = false;
  selectedCity!: CityResponse | undefined;
  cityDetails = {
    name: ''
  };
  f: any;
  imagePreview: string | null = null;
  fieldErrors: { [key: string]: string } = {};
  file!: File | null;

  constructor(private cityService: CityService) { }

  ngOnInit() {
    this.loadCities();
  }

  loadCities() {
    this.cityService.getCities().subscribe({
      next: (data) => {
        this.cityList = data;
      },
      error: (error) => {
        console.error('Error getting cities:', error);
      }
    });
  }

  openModalCreate() {
    this.openModal = true;
  }

  openEditModal(city: CityResponse) {
    this.cityService.getCity(city.id).subscribe({
      next: async (data) => {
        this.selectedCity = data;
        this.cityDetails = {
          name: data.name
        };
        try {
          const photoUrl = await this.loadPhoto(data.id);
          this.imagePreview = photoUrl;
        } catch (error) {
          console.error('Error loading photos:', error);
        }
        this.openModal = true;
      },
      error: (error) => {
        console.error('Error getting event:', error);
      }
    });
    this.f.resetForm(this.cityDetails);
  }

  loadPhoto(cityId: number): Promise<string> {
    return new Promise((resolve, reject) => {
      this.cityService.downloadCityPhoto(cityId).subscribe({
        next: (blob: Blob) => {
          this.createImageFromBlob(blob).then(
            url => resolve(url),
            error => reject(error)
          );
        },
        error: (error) => {
          reject(error);
        }
      });
    });
  }

  private createImageFromBlob(image: Blob): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onloadend = () => {
        resolve(reader.result as string);
      };
      reader.onerror = (error) => {
        reject(error);
      };
      if (image) {
        reader.readAsDataURL(image);
      } else {
        reject('No image provided');
      }
    });
  }

  closeModal() {
    this.openModal = false;
    this.selectedCity = undefined;
    this.imagePreview = null;
    this.fieldErrors = {};
    this.file = null;
    this.cityDetails = {
      name: ''
    };
  }

  onFileChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length) {
      this.file = input.files[0]; // Only take the first file
      if (this.file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = (e: any) => {
          const img = new Image();
          img.src = e.target.result;
          img.onload = () => {
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            if (ctx) {
              canvas.width = 500;
              canvas.height = 500;
              ctx.drawImage(img, 0, 0, 500, 500);
              const imageDataUrl = canvas.toDataURL(this.file!.type);
              this.imagePreview = imageDataUrl;
              if (this.selectedCity) {
                this.cityService.uploadPhoto(this.file!, this.selectedCity.id)
                  .subscribe({
                    next: (data) => {
                      console.log('Imagen cargada exitosamente:', data);
                    },
                    error: (error) => {
                      console.error('Error al cargar la imagen:', error);
                    }
                  });
              }
            }
          };
        };
        reader.readAsDataURL(this.file);
      }
    }
  }

  onSubmit() {
    if (this.selectedCity) {
      this.cityService.editCity(this.selectedCity.id, this.cityDetails.name, this.file!).subscribe({
        next: () => {
          this.closeModal();
          window.location.reload();
          this.fieldErrors = {};
          return true;
        },
        error: err => {
          if (err.status === 400) {

            this.fieldErrors = {};
            if (err.error["detail"].includes("'file' is not present")) {
              this.fieldErrors['file'] = "You have to choose an image for the city";
            }
          }
          return false;
        }
      })
    } else {
      this.cityService.createCity(this.cityDetails.name, this.file!).subscribe({
        next: () => {
          this.closeModal();
          window.location.reload();
          this.fieldErrors = {};
          return true;
        },
        error: err => {
          if (err.status === 400) {

            this.fieldErrors = {};
            if (err.error["detail"].includes("'file' is not present")) {
              this.fieldErrors['file'] = "You have to choose an image for the city";
            }
          }
          return false;
        }
      })
    }
  }

}
