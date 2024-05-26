import { Component, ViewChild } from '@angular/core';
import { EventResponse } from '../../models/event-list-response.interface';
import { EventService } from '../../services/events.service';
import { EventTypeResponse } from '../../models/event-type-response.inteface';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { EventDetailsResponse } from '../../models/event-details.interface';

@Component({
  selector: 'app-organizer-events',
  templateUrl: './organizer-events.component.html',
  styleUrl: './organizer-events.component.css'
})
export class OrganizerEventsComponent {
  @ViewChild('imageModal', { static: true }) imageModal: any;

  eventList: EventResponse[] = [];
  eventListPast: EventResponse[] = [];
  countFutureEvents = 0;
  currentPageFutureEvents = 0;
  pageForPaginationFuture = 0;
  countPastEvents = 0;
  currentPagePastEvents = 0;
  pageForPaginationPast = 0;
  selectedEvent!: EventDetailsResponse;
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
    city: ''
  };
  f: any;
  imagePreviews: string[] = [];
  selectedImage: string | null = null;
  imageWidth: number | null = null;
  imageHeight: number | null = null;

  constructor(private eventService: EventService, private modalService: NgbModal) { }

  ngOnInit() {
    this.loadNewPageFuture();
    this.loadNewPagePast();
  }

  loadNewPageFuture() {
    this.eventService.getFutureEventsByOrganizer().subscribe({
      next: (data) => {
        this.eventList = data.content;
        this.countFutureEvents = data.totalElements;
        this.currentPageFutureEvents = data.pageNumber;
        this.pageForPaginationFuture = this.currentPageFutureEvents + 1;
      },
      error: (error) => {
        console.error('Error getting events:', error);
      }
    });
  }

  loadNewPagePast() {
    this.eventService.getPastEventsByOrganizer().subscribe({
      next: (data) => {
        this.eventListPast = data.content;
        this.countPastEvents = data.totalElements;
        this.currentPagePastEvents = data.pageNumber;
        this.pageForPaginationPast = this.currentPageFutureEvents + 1;
      },
      error: (error) => {
        console.error('Error getting events:', error);
      }
    });
  }

  convertColorCode(colorCode: string): string {
    return `#${colorCode.slice(4)}`;
  }

  parseEventTypes(eventTypes: EventTypeResponse[]) {
    const etypes = eventTypes.map(et => et.name)
  }

  formatDateString(dateString: string): string {
    const date = new Date(dateString);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');

    return `${day}-${month}-${year} ${hours}:${minutes}`;
  }

  openModal(content: any, event: EventResponse) {
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
        try {
          const photoUrls = await Promise.all(data.urlPhotos.map((_, i) => this.loadPhoto(data.uuid, i)));
          this.imagePreviews = photoUrls;
        } catch (error) {
          console.error('Error loading photos:', error);
        }
      },
      error: (error) => {
        console.error('Error getting event:', error);
      }
    });
    this.modalService.open(content, { ariaLabelledBy: 'modal-title' });
    this.f.resetForm(this.eventDetails);
  }

  onFileChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length) {
      Array.from(input.files).forEach((file: File) => {
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
                this.imagePreviews.push(canvas.toDataURL(file.type));
              }
            };
          };
          reader.readAsDataURL(file);
        }
      });
    }
  }

  removeImage(index: number) {
    this.imagePreviews.splice(index, 1);
  }

  openModalImage(image: string, modalContent: any) {
    this.selectedImage = image;
    const img = new Image();
    img.src = this.selectedImage;
    this.modalService.open(modalContent, { size: 'md', scrollable: true });
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
    /*this.useService.editUse(this.selectedUse.id, this.useDetails).subscribe({
      next: data => {
        this.loadNewPage();
        this.modalService.dismissAll()
      },
      error: err => {
        console.error('Hubo un error al editar la estación:', err);
      }
    }
    );*/
    return true;
  }
}
