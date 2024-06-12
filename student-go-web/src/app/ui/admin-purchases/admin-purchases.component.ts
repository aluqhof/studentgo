import { Component } from '@angular/core';
import { PurchaseService } from '../../services/purchase.service';
import { Purchase } from '../../models/purchase-list-response.interface';
import { Event, PurchaseDetails } from '../../models/purchase-details.interface';
import { EventService } from '../../services/events.service';
import { StudentService } from '../../services/student.service';
import { Content } from '../../models/student-short-list-response.interface';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-admin-purchases',
  templateUrl: './admin-purchases.component.html',
  styleUrl: './admin-purchases.component.css'
})
export class AdminPurchasesComponent {

  purchaseList: Purchase[] = [];
  countPurchases: number = 0;
  currentPage: number = 0;
  pageSize: number = 0;
  totalPages: number = 0;
  openModal: boolean = false;
  purchaseDetails = {
    id: '',
    date: '',
    eventName: '',
    eventId: '',
    price: 0,
    studentName: '',
    studentId: '',
    city: '',
  };
  f: any;
  purchaseSelected!: PurchaseDetails | undefined;
  searchTerm: string = '';
  searchStudent: string = '';
  filteredEvents: Event[] = [];
  filteredStudents: Content[] = [];
  selectedStudent!: Content | undefined;
  selectedEvent!: Event | undefined;
  isSubmitEnabled: boolean = false;
  fieldErrors: { [key: string]: string } = {};
  searchPurchase: string = '';

  constructor(private purchaseService: PurchaseService, private eventService: EventService, private studentService: StudentService, public authService: AuthService) { }

  ngOnInit() {
    this.loadNewPage();
    //this.loadNewPagePast();
  }

  loadNewPage(page: number = 0) {
    this.purchaseService.getAllPurchases(page, this.searchPurchase).subscribe({
      next: (data) => {
        this.purchaseList = data.content;
        this.countPurchases = data.totalElements;
        this.currentPage = data.pageNumber;
        this.pageSize = data.size; // Assuming 'size' is part of the response
        this.totalPages = Math.ceil(this.countPurchases / this.pageSize);
      },
      error: (error) => {
        console.error('Error getting purchases:', error);
      }
    });
  }

  filterPurchase(search: string) {
    this.purchaseService.getAllPurchases(0, this.searchPurchase).subscribe({
      next: (data) => {
        this.purchaseList = data.content;
        this.countPurchases = data.totalElements;
        this.currentPage = data.pageNumber;
        this.pageSize = data.size;
        this.totalPages = Math.ceil(this.countPurchases / this.pageSize);
      },
      error: (error) => {
        console.error('Error getting purchases:', error);
      }
    });

  }

  changePageFuture(page: number): void {
    this.loadNewPage(page);
  }

  getArrayFromNumber(length: number): number[] {
    return new Array(length).fill(0).map((_, index) => index);
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

  formatDate(date: string | Date): string {
    // Si el parámetro date es una cadena, conviértelo a un objeto Date
    if (typeof date === 'string') {
      date = new Date(date);
    }

    // Asegúrate de que date es un objeto Date antes de llamar a toISOString
    if (date instanceof Date && !isNaN(date.valueOf())) {
      return date.toISOString().slice(0, 16); // '2024-06-09T12:34'
    }

    // Devuelve una cadena vacía o un valor predeterminado si la conversión falla
    return '';
  }

  filterEvents(search: string) {
    this.eventService.searchForEvent(search).subscribe({
      next: async (data) => {
        this.filteredEvents = data.content
        this.selectedEvent = undefined;
      }
    })
  }

  filterStudents(search: string) {
    this.studentService.searchForStudent(search).subscribe({
      next: async (data) => {
        this.filteredStudents = data.content
        this.selectedStudent = undefined;
      }
    })
  }

  selectEvent(event: Event) {
    this.searchTerm = event.name;
    this.selectedEvent = event;
    this.filteredEvents = [];
    this.checkSubmitEnabled();
  }

  selectStudent(student: Content) {
    this.searchStudent = student.username;
    this.selectedStudent = student;
    this.filteredStudents = [];
    this.checkSubmitEnabled();
  }

  checkSubmitEnabled() {
    this.isSubmitEnabled = !!this.selectedEvent && !!this.selectedStudent; // Habilitar si ambos campos están seleccionados
  }


  openModalCreate() {
    this.openModal = true;
  }

  openEditModal(purchase: Purchase) {
    this.purchaseService.getPurchaseDetails(purchase.purchaseId).subscribe({
      next: async (data) => {
        this.purchaseSelected = data;
        this.purchaseDetails = {
          id: data.purchaseId,
          date: this.formatDate(data.dateTime),
          eventName: data.event.name,
          eventId: data.event.uuid,
          price: data.price,
          studentName: data.student.username,
          studentId: data.student.id,
          city: data.event.cityId,
        };
        this.searchTerm = data.event.name;
        this.searchStudent = data.student.username;
        this.selectedEvent = data.event;
        this.selectedStudent = data.student;
        this.openModal = true;
      },
      error: (error) => {
        console.error('Error getting purchase:', error);
      }
    });
  }

  closeModal() {
    this.openModal = false;
    this.purchaseSelected = undefined;
    this.selectedEvent = undefined;
    this.selectedStudent = undefined;
    this.searchTerm = '';
    this.searchStudent = '';
    this.purchaseDetails = {
      id: '',
      date: '',
      eventName: '',
      eventId: '',
      price: 0,
      studentName: '',
      studentId: '',
      city: '',
    };
  }

  closeList() {
    this.filteredEvents = [];
  }

  onSubmit() {
    if (this.purchaseSelected) {
      this.purchaseService.editPurchase(this.purchaseSelected.purchaseId, {
        eventId: this.selectedEvent!.uuid.toString(),
        studentId: this.selectedStudent!.id.toString(),
        price: this.purchaseDetails.price
      }).subscribe({
        next: data => {
          this.closeModal();
          window.location.reload();
        },
        error: err => {
          if (err.status === 400 && err.error && err.error["Fields errors"]) {
            this.fieldErrors = {};
            err.error["Fields errors"].forEach((fieldError: any) => {
              this.fieldErrors[fieldError.field] = fieldError.message;
            });
          }
        }
      });
      this.selectedEvent = undefined;
      this.selectedStudent = undefined;
      this.searchStudent = '';
      this.searchTerm = '';
      return true;
    } else {
      this.purchaseService.makePurchase(
        {
          eventId: this.selectedEvent!.uuid.toString(),
          studentId: this.selectedStudent!.id.toString(),
          price: this.purchaseDetails.price
        }
      ).subscribe({
        next: data => {
          this.closeModal();
          window.location.reload();
        },
        error: err => {
          console.error('Hubo un error al crear el evento:', err);
        }
      });
      this.selectedEvent = undefined;
      this.selectedStudent = undefined;
      this.searchStudent = '';
      this.searchTerm = '';
      return true;
    }
  }
}
