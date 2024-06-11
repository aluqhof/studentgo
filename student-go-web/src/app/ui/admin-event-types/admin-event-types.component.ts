import { Component } from '@angular/core';
import { EventTypeResponse } from '../../models/event-type-response.inteface';
import { EventTypeService } from '../../services/event-type.service';

@Component({
  selector: 'app-admin-event-types',
  templateUrl: './admin-event-types.component.html',
  styleUrl: './admin-event-types.component.css'
})
export class AdminEventTypesComponent {

  eventTypeList: EventTypeResponse[] = [];
  openModal: boolean = false;
  openModalDelete: boolean = false;
  selectedEventType!: EventTypeResponse | undefined;
  eventTypeDetails = {
    name: '',
    iconRef: '',
    colorCode: ''
  };
  f: any;
  fieldErrors: { [key: string]: string } = {};

  constructor(private eventTypeService: EventTypeService) { }

  ngOnInit() {
    this.loadEventTypes();
  }

  loadEventTypes() {
    this.eventTypeService.getEventTypes().subscribe({
      next: (data) => {
        this.eventTypeList = data;
      },
      error: (error) => {
        console.error('Error getting cities:', error);
      }
    })
  }

  openModalCreate() {
    this.openModal = true;
    this.closeDeleteModal();
  }

  openEditModal(eventType: EventTypeResponse) {
    this.closeDeleteModal();
    this.eventTypeService.getEventType(eventType.id).subscribe({
      next: async (data) => {
        this.selectedEventType = data;
        this.eventTypeDetails = {
          name: data.name,
          iconRef: data.iconRef,
          colorCode: data.colorCode
        };
        this.openModal = true;
      },
      error: (error) => {
        console.error('Error getting event:', error);
      }
    });
    this.f.resetForm(this.eventTypeDetails);
  }

  openDeleteModal(eventType: EventTypeResponse) {
    this.closeModal();
    this.eventTypeService.getEventType(eventType.id).subscribe({
      next: async (data) => {
        this.selectedEventType = data;
        this.eventTypeDetails = {
          name: data.name,
          iconRef: data.iconRef,
          colorCode: data.colorCode
        };
        this.openModalDelete = true;
      },
      error: (error) => {
        console.error('Error getting event types:', error);
      }
    });
  }

  closeDeleteModal() {
    this.openModalDelete = false
    this.selectedEventType = undefined;
  }

  closeModal() {
    this.openModal = false;
    this.selectedEventType = undefined;
    this.fieldErrors = {};
    this.eventTypeDetails = {
      name: '',
      iconRef: '',
      colorCode: ''
    };
  }

  onSubmit() {
    if (this.selectedEventType) {
      this.eventTypeService.editEventType(this.selectedEventType.id, {
        name: this.eventTypeDetails.name,
        iconRef: this.eventTypeDetails.iconRef,
        colorCode: this.eventTypeDetails.colorCode
      }).subscribe({
        next: () => {
          this.closeModal();
          window.location.reload();
          this.fieldErrors = {};
          return true;
        },
        error: err => {
          if (err.status === 400) {
            if (err.error && err.error["Fields errors"]) {
              this.fieldErrors = {};
              err.error["Fields errors"].forEach((fieldError: any) => {
                this.fieldErrors[fieldError.field] = fieldError.message;
              });
            } else {
              this.fieldErrors = {};
              if (err.error["title"].includes("Invalid name error")) {
                this.fieldErrors['name'] = err.error["detail"];
              }
            }
          }
          return false;
        }
      })
    } else {
      this.eventTypeService.createEventType({
        name: this.eventTypeDetails.name,
        iconRef: this.eventTypeDetails.iconRef,
        colorCode: this.eventTypeDetails.colorCode
      }).subscribe({
        next: () => {
          this.closeModal();
          window.location.reload();
          this.fieldErrors = {};
          return true;
        },
        error: err => {
          if (err.status === 400) {
            if (err.error && err.error["Fields errors"]) {
              this.fieldErrors = {};
              err.error["Fields errors"].forEach((fieldError: any) => {
                this.fieldErrors[fieldError.field] = fieldError.message;
              });
            } else {
              this.fieldErrors = {};
              if (err.error["title"].includes("Invalid name error")) {
                this.fieldErrors['name'] = err.error["detail"];
              }
            }
          }
          return false;
        }
      })
    }
  }

  submitDelete() {
    if (this.selectedEventType) {
      this.eventTypeService.deleteEventType(this.selectedEventType.id).subscribe({
        next: data => {
          this.closeDeleteModal();
          window.location.reload();
        },
        error: error => {
          console.error('Error deleting event type:', error);
        }
      })
    }
  }
}

