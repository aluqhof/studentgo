import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable, inject } from "@angular/core";
import { TokenStorageService } from "./token-storage.service";
import { Observable } from "rxjs";
import { RegisterForm } from "../models/register-form.interface";
import { UserResponse } from "../models/user-response.interface";
import { environment } from "../../environments/environment";

const httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
}

@Injectable({
    providedIn: 'root'
})
export class AuthService {

    constructor(private http: HttpClient) { }
    userRole!: string;
    tokenStorageService!: TokenStorageService;

    registerUser(form: RegisterForm): Observable<UserResponse> {
        return this.http.post<UserResponse>(`http://localhost:8080/auth/register-student`,
            {
                "username": form.username,
                "password": form.password,
                "verifyPassword": form.verifyPassword,
                "email": form.email,
                "name": form.name,
                "interests": form.interests,
            }, httpOptions);
    }

    login(username: string, password: string): Observable<UserResponse> {
        return this.http.post<UserResponse>(`http://localhost:8080/auth/login`, {
            username,
            password
        });
    }


    isAdmin(): boolean {
        if (inject(TokenStorageService).getUser().role === 'ROLE_ADMIN') return true;

        return false;
    }

    isOrganizer(): boolean {
        if (inject(TokenStorageService).getUser().role === 'ROLE_ORGANIZER') return true;

        return false;
    }
}