import { HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable, throwError } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class ErrorHandlerService {

    constructor(private router: Router) { }

    handleHttpError(error: HttpErrorResponse): Observable<never> {
        console.error('Error occurred:', error);

        // Manejar diferentes códigos de estado
        if (error.status === 404) {
            // Recurso no encontrado
            // Redirigir a la página de error 404
            this.router.navigate(['/error-404']);
            return throwError(error as never);
        }

        if (error.status === 403) {
            // Acceso denegado
            // Redirigir a la página de acceso denegado
            this.router.navigate(['/access-denied']);
            return throwError(error as never);
        }

        if (error.status === 400) {
            // Solicitud incorrecta
            // Redirigir a la página de error 400
            this.router.navigate(['/error-400']);
            return throwError(error as never);
        }

        // Otros códigos de estado
        // Redirigir a una página de error general
        this.router.navigate(['/error']);
        return throwError(error as never);
    }
}