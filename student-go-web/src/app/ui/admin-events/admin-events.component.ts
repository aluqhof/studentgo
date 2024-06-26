import { Component, ViewChild } from '@angular/core';
import { EventResponse } from '../../models/event-list-response.interface';
import { EventDetailsResponse } from '../../models/event-details.interface';
import { EventService } from '../../services/events.service';
import { HttpClient } from '@angular/common/http';
import { EventTypeResponse } from '../../models/event-type-response.inteface';
import { CityService } from '../../services/city.service';
import { CityResponse } from '../../models/city-response.interface';
import { EventTypeService } from '../../services/event-type.service';
import { AuthService } from '../../services/auth.service';
import { OrganizerService } from '../../services/organizer-service';
import { Organizer } from '../../models/organizer-page-response.interface';

@Component({
  selector: 'app-admin-events',
  templateUrl: './admin-events.component.html',
  styleUrls: ['./admin-events.component.css']
})
export class AdminEventsComponent {

  @ViewChild('imageModal', { static: true }) imageModal: any;

  eventList: EventResponse[] = [];
  eventListPast: EventResponse[] = [];
  countFutureEvents = 0;
  currentPageFutureEvents = 0;
  pageSizeFuture = 10;
  totalPagesFuture = 0;
  countPastEvents = 0;
  currentPagePastEvents = 0;
  pageSizePast = 10;
  totalPagesPast = 0;
  selectedEvent!: EventDetailsResponse | undefined;
  eventDetails = {
    id: '',
    date: '',
    name: '',
    description: '',
    price: 0,
    eventTypes: [''],
    maxCapacity: 0,
    latitude: 0,
    longitude: 0,
    city: '',
  };
  author: string = '';
  f: any;
  imagePreviews: string[] = [];
  selectedImage: string | null = null;
  imageWidth: number | null = null;
  imageHeight: number | null = null;
  loading: boolean = false;
  openModal: boolean = false;
  cities: CityResponse[] = [];
  eventTypes: EventTypeResponse[] = [];
  selectedEt: EventTypeResponse[] = [];
  citySelected!: string;
  citiesUnselected: string[] = [];
  files: File[] = [];
  fieldErrors: { [key: string]: string } = {};
  filteredOrganizers: Organizer[] = [];
  selectedOrganizer: Organizer | undefined;
  searchOrganizer: string = '';
  isSubmitEnabled: boolean = false;
  pastEventList: EventResponse[] = [];
  searchFuture: string = '';
  searchPast: string = '';

  constructor(private cityService: CityService, private eventTypeService: EventTypeService, private eventService: EventService, public authService: AuthService, private organizerService: OrganizerService) { }

  ngOnInit() {
    this.loadNewPageFuture();
    this.getAllCities();
    this.getAllEventTypes();
    this.loadNewPagePast();
    //this.loadNewPagePast();
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

  getAllEventTypes() {
    this.eventTypeService.getEventTypes().subscribe({
      next: (data) => {
        this.eventTypes = data;
      },
      error: (error) => {
        console.error('Error getting event types:', error);
      }
    });
  }

  filterOrganizers(search: string) {
    this.organizerService.searchOrganizer(search).subscribe({
      next: async (data) => {
        this.filteredOrganizers = data.content
        this.selectedOrganizer = undefined;
      }
    })
  }

  filterFutureEvents(search: string) {
    if (this.authService.isAdmin()) {
      this.eventService.getUpcomingEvents(0, this.searchFuture).subscribe({
        next: async (data) => {
          this.eventList = data.content;
          this.countFutureEvents = data.totalElements;
          this.currentPageFutureEvents = data.pageNumber;
          this.pageSizeFuture = data.size;
          this.totalPagesFuture = Math.ceil(this.countFutureEvents / this.pageSizeFuture);
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      })
    } else if (this.authService.isOrganizer()) {
      this.eventService.getUpcomingEventsByOrganizer(0, this.searchFuture).subscribe({
        next: async (data) => {
          this.eventList = data.content;
          this.countFutureEvents = data.totalElements;
          this.currentPageFutureEvents = data.pageNumber;
          this.pageSizeFuture = data.size;
          this.totalPagesFuture = Math.ceil(this.countFutureEvents / this.pageSizeFuture);
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      })
    }
  }

  filterPastEvents(search: string) {
    if (this.authService.isAdmin()) {
      this.eventService.getPastEventsByAdmin(0, this.searchPast).subscribe({
        next: async (data) => {
          this.pastEventList = data.content;
          this.countPastEvents = data.totalElements;
          this.currentPagePastEvents = data.pageNumber;
          this.pageSizePast = data.size;
          this.totalPagesPast = Math.ceil(this.countPastEvents / this.pageSizePast);;
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      })
    } else if (this.authService.isOrganizer()) {
      this.eventService.getPastEventsByOrganizer(0, this.searchPast).subscribe({
        next: async (data) => {
          this.pastEventList = data.content;
          this.countPastEvents = data.totalElements;
          this.currentPagePastEvents = data.pageNumber;
          this.pageSizePast = data.size;
          this.totalPagesPast = Math.ceil(this.countPastEvents / this.pageSizePast);;
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      })
    }
  }

  selectOrganizer(organizer: Organizer) {
    this.searchOrganizer = organizer.username;
    this.selectedOrganizer = organizer;
    this.filteredOrganizers = [];
    this.checkSubmitEnabled();
  }

  checkSubmitEnabled() {
    this.isSubmitEnabled = !!this.selectedOrganizer; // Habilitar si ambos campos están seleccionados
  }

  getMinDate(): string {
    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = (currentDate.getMonth() + 1).toString().padStart(2, '0');
    const day = currentDate.getDate().toString().padStart(2, '0');
    const hours = currentDate.getHours().toString().padStart(2, '0');
    const minutes = currentDate.getMinutes().toString().padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  }

  loadNewPageFuture(page: number = 0) {
    if (this.authService.isAdmin()) {
      this.eventService.getUpcomingEvents(page, this.searchFuture).subscribe({
        next: (data) => {
          this.eventList = data.content;
          this.countFutureEvents = data.totalElements;
          this.currentPageFutureEvents = data.pageNumber;
          this.pageSizeFuture = data.size;
          this.totalPagesFuture = Math.ceil(this.countFutureEvents / this.pageSizeFuture);
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      });
    } else if (this.authService.isOrganizer()) {
      this.eventService.getUpcomingEventsByOrganizer(page, this.searchFuture).subscribe({
        next: (data) => {
          this.eventList = data.content;
          this.countFutureEvents = data.totalElements;
          this.currentPageFutureEvents = data.pageNumber;
          this.pageSizeFuture = data.size;
          this.totalPagesFuture = Math.ceil(this.countFutureEvents / this.pageSizeFuture);
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      });
    }
  }

  loadNewPagePast(page: number = 0) {
    if (this.authService.isAdmin()) {
      this.eventService.getPastEventsByAdmin(page, this.searchPast).subscribe({
        next: (data) => {
          this.pastEventList = data.content;
          this.countPastEvents = data.totalElements;
          this.currentPagePastEvents = data.pageNumber;
          this.pageSizePast = data.size;
          this.totalPagesPast = Math.ceil(this.countPastEvents / this.pageSizePast);
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      });
    } else if (this.authService.isOrganizer()) {
      this.eventService.getPastEventsByOrganizer(page, this.searchPast).subscribe({
        next: (data) => {
          this.pastEventList = data.content;
          this.countPastEvents = data.totalElements;
          this.currentPagePastEvents = data.pageNumber;
          this.pageSizePast = data.size;
          this.totalPagesPast = Math.ceil(this.countPastEvents / this.pageSizePast);
        },
        error: (error) => {
          console.error('Error getting events:', error);
        }
      });
    }
  }

  addInterest(event: any) {
    const selectedEventType = JSON.parse(event.target.value);
    if (selectedEventType) {
      this.selectedEt.push(selectedEventType);
      this.eventTypes = this.eventTypes.filter(item => item.id !== selectedEventType.id);
    }
  }

  addCity(event: string | any) {
    const selectedCity: string = event.target.value;
    if (selectedCity) {
      this.citiesUnselected = this.cities.map(c => c.name);
      this.citiesUnselected = this.citiesUnselected.filter(c => selectedCity.substring(3) !== c);
      this.citySelected = selectedCity.substring(3);
    }
  }

  removeInterest(selectedEventType: EventTypeResponse) {
    if (selectedEventType) {
      this.eventTypes.push(selectedEventType);
      this.selectedEt = this.selectedEt.filter(item => item.id !== selectedEventType.id);
    }
  }

  changePageFuture(page: number): void {
    this.loadNewPageFuture(page);
  }

  changePagePast(page: number): void {
    this.loadNewPagePast(page);
  }

  getArrayFromNumber(length: number): number[] {
    return new Array(length).fill(0).map((_, index) => index);
  }

  convertColorCode(colorCode: string): string {
    return `#${colorCode.slice(4)}`;
  }

  formatDateInputString(dateString: string): string {
    return dateString.split('T')[0];
  }

  formatTimeString(dateString: string): string {
    return dateString.split('T')[1].substring(0, 5);
  }

  updateDate(event: any) {
    const newDate = event.target ? event.target.value : '';
    const timePart = this.eventDetails.date.split('T')[1]; // Obtener la parte de la hora actual
    this.eventDetails.date = newDate + 'T' + timePart; // Concatenar la nueva fecha con la hora actual
  }

  updateTime(event: any) {
    const newTime = event.target ? event.target.value : '';
    const datePart = this.eventDetails.date.split('T')[0]; // Obtener la parte de la fecha actual
    this.eventDetails.date = datePart + 'T' + newTime; // Concatenar la fecha actual con la nueva hora
  }

  formatDateString(dateString: string): string {
    const date = new Date(dateString);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  openModalCreate() {
    this.citiesUnselected = this.cities.map(c => c.name);
    this.openModal = true;
    this.f.resetForm(this.eventDetails);
  }

  openEditModal(event: EventResponse) {
    this.eventService.getEventDetails(event.uuid).subscribe({
      next: async (data) => {
        this.selectedEvent = data;
        this.eventDetails = {
          id: data.uuid,
          date: data.dateTime.toString(),
          name: data.name,
          description: data.description,
          price: data.price,
          eventTypes: data.eventType,
          maxCapacity: data.maxCapacity,
          latitude: data.latitude,
          longitude: data.longitude,
          city: data.cityId
        };
        this.searchOrganizer = data.organizer.username;
        this.selectedOrganizer = data.organizer;
        this.eventTypes.forEach(et => {
          if (this.eventDetails.eventTypes.includes(et.name)) {
            this.selectedEt.push(et);
            this.eventTypes = this.eventTypes.filter(item => item.id !== et.id);
          }
        });
        this.cities.forEach(city => {
          if (city.name === this.eventDetails.city) {
            this.citySelected = city.name;
            this.citiesUnselected = this.cities.map(c => c.name).filter(c => c !== city.name);
          }
        });
        try {
          const photoUrls = await Promise.all(data.urlPhotos.map((_, i) => this.loadPhoto(data.uuid, i)));
          this.imagePreviews = photoUrls;
        } catch (error) {
          console.error('Error loading photos:', error);
        }
        this.openModal = true;
      },
      error: (error) => {
        console.error('Error getting event:', error);
      }
    });
    this.f.resetForm(this.eventDetails);
  }

  closeModal() {
    this.openModal = false;
    this.selectedEvent = undefined;
    this.imagePreviews = [];
    this.files = [];
    this.selectedEt = [];
    this.eventTypes = [];
    this.selectedOrganizer = undefined
    this.searchOrganizer = '';
    this.getAllEventTypes();
    this.eventDetails = {
      id: '',
      date: '',
      name: '',
      description: '',
      price: 0,
      eventTypes: [''],
      maxCapacity: 0,
      latitude: 0,
      longitude: 0,
      city: ''
    };
  }

  onFileChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length) {
      Array.from(input.files).forEach((file: File) => {
        this.files.push(file); // Almacena el archivo en la lista de archivos
        if (file.type.startsWith('image/')) {
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
                const imageDataUrl = canvas.toDataURL(file.type);
                this.imagePreviews.push(imageDataUrl);
                // Llama al servicio para cargar la imagen
                if (this.selectedEvent) {
                  this.eventService.uploadEventPhotos([file], this.eventDetails.id)
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
          reader.readAsDataURL(file);
        }
      });
    }
  }

  removeImage(index: number) {
    if (this.selectedEvent) {
      this.eventService.deleteEventPhoto(this.eventDetails.id, index)
        .subscribe({
          next: (data) => {
            this.files.splice(index, 1)
            this.imagePreviews.splice(index, 1);
          },
          error: (error) => {
            console.error("Error al borrar la imagen");
          }
        });
    } else {
      this.files.splice(index, 1)
      this.imagePreviews.splice(index, 1);
    }
  }

  openModalImage(image: string, modalContent: any) {
    this.selectedImage = image;
    const img = new Image();
    img.src = this.selectedImage;
    //this.modalService.open(modalContent, { size: 'md', scrollable: true });
  }

  loadPhoto(eventId: string, index: number): Promise<string> {
    return new Promise((resolve, reject) => {
      this.eventService.getEventPhoto(eventId, index).subscribe({
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

  onSubmit() {
    if (this.selectedEvent) {
      if (this.files.length === 0 && this.imagePreviews.length === 0) {
        this.fieldErrors['photo'] = "You have to choose a photo";
        return false
      }
      if (this.authService.isOrganizer()) {
        this.eventService.editEventOrganizer(this.eventDetails.id, {
          name: this.eventDetails.name,
          dateTime: this.formatDateString(this.eventDetails.date),
          description: this.eventDetails.description,
          price: this.eventDetails.price,
          maxCapacity: this.eventDetails.maxCapacity,
          cityId: this.citySelected,
          latitude: this.eventDetails.latitude,
          longitude: this.eventDetails.longitude,
          eventTypes: this.selectedEt.map(et => et.name)
        }).subscribe({
          next: data => {
            this.closeModal();
            window.location.reload();
          },
          error: err => {
            console.error('Hubo un error al editar el evento:', err);
          }
        });
      } else if (this.authService.isAdmin()) {
        this.eventService.editEventAdmin(this.eventDetails.id, {
          name: this.eventDetails.name,
          dateTime: this.formatDateString(this.eventDetails.date),
          description: this.eventDetails.description,
          price: this.eventDetails.price,
          maxCapacity: this.eventDetails.maxCapacity,
          cityId: this.citySelected,
          latitude: this.eventDetails.latitude,
          longitude: this.eventDetails.longitude,
          eventTypes: this.selectedEt.map(et => et.name),
          author: this.selectedOrganizer?.id!
        }).subscribe({
          next: data => {
            this.closeModal();
            window.location.reload();
          },
          error: err => {
            console.error('Hubo un error al editar el evento:', err);
          }
        });
      }
      this.selectedOrganizer = undefined;
      this.searchOrganizer = '';
      return true;
    } else {
      if (this.files.length === 0) {
        this.fieldErrors['photo'] = "You have to choose a photo";
        return false
      }
      if (this.authService.isOrganizer()) {
        this.eventService.createEventOrganizer(
          {
            name: this.eventDetails.name,
            dateTime: this.formatDateString(this.eventDetails.date),
            description: this.eventDetails.description,
            price: this.eventDetails.price,
            maxCapacity: this.eventDetails.maxCapacity,
            cityId: this.citySelected,
            latitude: this.eventDetails.latitude,
            longitude: this.eventDetails.longitude,
            eventTypes: this.selectedEt.map(et => et.name)
          },
          this.files // Pasa los archivos directamente
        ).subscribe({
          next: data => {
            this.closeModal();
            window.location.reload();
          },
          error: err => {
            console.error('Hubo un error al crear el evento:', err);
          }
        });
      } else if (this.authService.isAdmin()) {
        this.eventService.createEventAdmin(
          {
            name: this.eventDetails.name,
            dateTime: this.formatDateString(this.eventDetails.date),
            description: this.eventDetails.description,
            price: this.eventDetails.price,
            maxCapacity: this.eventDetails.maxCapacity,
            cityId: this.citySelected,
            latitude: this.eventDetails.latitude,
            longitude: this.eventDetails.longitude,
            eventTypes: this.selectedEt.map(et => et.name),
            author: this.selectedOrganizer?.id!
          },
          this.files // Pasa los archivos directamente
        ).subscribe({
          next: data => {
            this.closeModal();
            window.location.reload();
          },
          error: err => {
            console.error('Hubo un error al crear el evento:', err);
          }
        });
        this.selectedOrganizer = undefined;
        this.searchOrganizer = '';
      }
      return true;
    }
  }
}
