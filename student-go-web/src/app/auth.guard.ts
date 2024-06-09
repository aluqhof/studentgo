import { Injectable, inject } from "@angular/core";
import { ActivatedRouteSnapshot, CanActivateFn, Router, RouterStateSnapshot } from "@angular/router";
import { Observable, of } from "rxjs";
import { AuthService } from "./services/auth.service";

@Injectable({
    providedIn: 'root'
})
class PermissionService {
    constructor(private authService: AuthService, private router: Router) { }

    canActivateAdmin(
        next: ActivatedRouteSnapshot,
        state: RouterStateSnapshot
    ): Observable<boolean> {
        const isAdmin = this.authService.isAdmin();
        if (!isAdmin) {
            this.router.navigate(['/access-denied']); // Redirigir a una página de acceso denegado si no es admin
        }
        return of(isAdmin);
    }

    canActivateStudent(
        next: ActivatedRouteSnapshot,
        state: RouterStateSnapshot
    ): Observable<boolean> {
        const isStudent = this.authService.isStudent();
        if (!isStudent) {
            this.router.navigate(['/access-denied']); // Redirigir a una página de acceso denegado si no es estudiante
        }
        return of(isStudent);
    }

    canActivateOrganizer(
        next: ActivatedRouteSnapshot,
        state: RouterStateSnapshot
    ): Observable<boolean> {
        const isOrganizer = this.authService.isOrganizer();
        if (!isOrganizer) {
            this.router.navigate(['/access-denied']); // Redirigir a una página de acceso denegado si no es organizador
        }
        return of(isOrganizer);
    }


}


export const AdminGuard: CanActivateFn = (
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
): Observable<boolean> => {
    return inject(PermissionService).canActivateAdmin(next, state);
};

export const StudentGuard: CanActivateFn = (
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
): Observable<boolean> => {
    return inject(PermissionService).canActivateStudent(next, state);
};

export const OrganizerGuard: CanActivateFn = (
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
): Observable<boolean> => {
    return inject(PermissionService).canActivateOrganizer(next, state);
};