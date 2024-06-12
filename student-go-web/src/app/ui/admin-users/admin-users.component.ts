import { Component } from '@angular/core';
import { Student } from '../../models/student-item-response.interface';
import { StudentService } from '../../services/student.service';
import { EventTypeService } from '../../services/event-type.service';
import { EventTypeResponse } from '../../models/event-type-response.inteface';

@Component({
  selector: 'app-admin-users',
  templateUrl: './admin-users.component.html',
  styleUrl: './admin-users.component.css'
})
export class AdminUsersComponent {

  studentList: Student[] = [];
  countPurchases: number = 0;
  currentPage: number = 0;
  pageSize: number = 0;
  totalPages: number = 0;
  openModal: boolean = false;
  selectedStudent!: Student | undefined;
  studentDetails = {
    username: '',
    name: '',
    description: '',
    email: '',
    eventTypes: [''],
  };
  f: any;
  eventTypes: EventTypeResponse[] = [];
  selectedEt: EventTypeResponse[] = [];
  imagePreview: string | null = null;
  fieldErrors: { [key: string]: string } = {};
  searchTerm: string = '';


  constructor(private studentService: StudentService, private eventTypeService: EventTypeService) { }

  ngOnInit() {
    this.loadNewPage();
    this.getAllEventTypes();
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

  formatDateString(dateString: string): string {
    const date = new Date(dateString);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  convertColorCode(colorCode: string): string {
    return `#${colorCode.slice(4)}`;
  }

  loadNewPage(page: number = 0) {
    this.studentService.findAllStudents(page, this.searchTerm).subscribe({
      next: (data) => {
        this.studentList = data.content;
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

  filterStudents(searchTerm: string) {
    this.studentService.findAllStudents(0, searchTerm).subscribe({
      next: (data) => {
        this.studentList = data.content;
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

  addInterest(event: any) {
    const selectedEventType = JSON.parse(event.target.value);
    if (selectedEventType) {
      this.selectedEt.push(selectedEventType);
      this.eventTypes = this.eventTypes.filter(item => item.id !== selectedEventType.id);
    }
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

  removeInterest(selectedEventType: EventTypeResponse) {
    if (selectedEventType) {
      this.eventTypes.push(selectedEventType);
      this.selectedEt = this.selectedEt.filter(item => item.id !== selectedEventType.id);
    }
  }

  openEditModal(student: Student) {
    this.studentService.getStudentById(student.id).subscribe({
      next: async (data) => {
        this.selectedStudent = data;
        this.studentDetails = {
          username: data.username,
          name: data.name,
          description: data.description,
          email: data.email,
          eventTypes: data.interests.map(et => et.name),
        };
        this.eventTypes.forEach(et => {
          if (this.selectedStudent!.interests.map(et => et.name).includes(et.name)) {
            this.selectedEt.push(et);
            this.eventTypes = this.eventTypes.filter(item => item.id !== et.id);
          }
        });
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
    this.f.resetForm(this.studentDetails);
  }

  loadPhoto(userId: string): Promise<string> {
    return new Promise((resolve, reject) => {
      this.studentService.getUserPhoto(userId).subscribe({
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
    this.studentService.editStudent(this.selectedStudent!.id, {
      username: this.studentDetails.username,
      name: this.studentDetails.name,
      description: this.studentDetails.description,
      email: this.studentDetails.email,
      eventTypes: this.selectedEt.map(et => et.name),
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
            if (err.error["title"].includes("Username exist error")) {
              this.fieldErrors['username'] = err.error.detail;
            }
            if (err.error["title"].includes("Email exist error")) {
              this.fieldErrors['email'] = err.error.detail;
            }
          }
        }
        return false;
      }
    })
  }

  closeModal() {
    this.openModal = false;
    this.selectedStudent = undefined;
    this.selectedEt = [];
    this.eventTypes = [];
    this.getAllEventTypes();
    this.imagePreview = null;
    this.fieldErrors = {};
    //this.imagePreviews = [];
    //this.files = [];
    this.studentDetails = {
      username: '',
      name: '',
      description: '',
      email: '',
      eventTypes: [''],
    };
  }

  onFileChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length) {
      const file = input.files[0]; // Only take the first file
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
              this.imagePreview = imageDataUrl;
              if (this.selectedStudent) {
                this.studentService.uploadProfilePhoto(file, this.selectedStudent.id)
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
    }
  }
}
