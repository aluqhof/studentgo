import { Component } from '@angular/core';
import { Organizer } from '../../models/organizer-list.interface';
import { OrganizerService } from '../../services/organizer-service';
import { StudentService } from '../../services/student.service';

@Component({
  selector: 'app-admin-organizers',
  templateUrl: './admin-organizers.component.html',
  styleUrl: './admin-organizers.component.css'
})
export class AdminOrganizersComponent {

  organizerList: Organizer[] = [];
  countPurchases: number = 0;
  currentPage: number = 0;
  pageSize: number = 0;
  totalPages: number = 0;
  openModal: boolean = false;
  selectedOrganizer!: Organizer | undefined;
  organizerDetails = {
    username: '',
    name: '',
    description: '',
    email: '',
    business: '',
  };
  f: any;
  imagePreview: string | null = null;
  fieldErrors: { [key: string]: string } = {};
  searchTerm: string = ''

  constructor(private organizerService: OrganizerService, private studentService: StudentService) { }

  ngOnInit() {
    this.loadNewPage();
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

  loadNewPage(page: number = 0) {
    this.organizerService.findAllOrganizer(page, this.searchTerm).subscribe({
      next: (data) => {
        this.organizerList = data.content;
        this.countPurchases = data.totalElements;
        this.currentPage = data.pageNumber;
        this.pageSize = data.size;
        this.totalPages = Math.ceil(this.countPurchases / this.pageSize);
      },
      error: (error) => {
        console.error('Error getting organizers:', error);
      }
    });
  }

  filterOrganizers(searchTerm: string) {
    this.organizerService.findAllOrganizer(0, searchTerm).subscribe({
      next: (data) => {
        this.organizerList = data.content;
        this.countPurchases = data.totalElements;
        this.currentPage = data.pageNumber;
        this.pageSize = data.size;
        this.totalPages = Math.ceil(this.countPurchases / this.pageSize);
      },
      error: (error) => {
        console.error('Error getting organizers:', error);
      }
    });
  }

  changePageFuture(page: number): void {
    this.loadNewPage(page);
  }

  getArrayFromNumber(length: number): number[] {
    return new Array(length).fill(0).map((_, index) => index);
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

  openModalCreate() {
    this.openModal = true;
  }

  openEditModal(organizer: Organizer) {
    this.organizerService.getOrganizer(organizer.id).subscribe({
      next: async (data) => {
        this.selectedOrganizer = data;
        this.organizerDetails = {
          username: data.username,
          name: data.name,
          description: data.description,
          email: data.email,
          business: data.business
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
    this.f.resetForm(this.organizerDetails);
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

  closeModal() {
    this.openModal = false;
    this.selectedOrganizer = undefined;
    this.imagePreview = null;
    this.fieldErrors = {};
    //this.imagePreviews = [];
    //this.files = [];
    this.organizerDetails = {
      username: '',
      name: '',
      description: '',
      email: '',
      business: '',
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
              if (this.selectedOrganizer) {
                this.studentService.uploadProfilePhoto(file, this.selectedOrganizer.id)
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

  onSubmit() {
    if (this.selectedOrganizer) {
      this.organizerService.editOrganizer(this.selectedOrganizer.id, {
        username: this.organizerDetails.username,
        name: this.organizerDetails.name,
        description: this.organizerDetails.description,
        email: this.organizerDetails.email,
        business: this.organizerDetails.business,
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
    } else {
      this.organizerService.createOrganizer({
        username: this.organizerDetails.username,
        name: this.organizerDetails.name,
        description: this.organizerDetails.description,
        email: this.organizerDetails.email,
        business: this.organizerDetails.business,
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
  }
}
