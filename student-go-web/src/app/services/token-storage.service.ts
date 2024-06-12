import { Injectable } from '@angular/core';

const TOKEN_KEY = 'auth-token';
const USER_KEY = 'auth-user';

@Injectable({
    providedIn: 'root'
})
export class TokenStorageService {

    constructor() { }

    signOut(): void {
        localStorage.clear();
    }

    public saveToken(token: string): void {
        if (typeof localStorage !== 'undefined') {
            localStorage.removeItem(TOKEN_KEY);
            localStorage.setItem(TOKEN_KEY, token);
        }
    }

    public getToken(): string | null {
        if (typeof localStorage !== 'undefined') {
            return localStorage.getItem(TOKEN_KEY);
        }
        return null;
    }

    public saveUser(user: any): void {
        if (typeof localStorage !== 'undefined') {
            localStorage.removeItem(USER_KEY);
            localStorage.setItem(USER_KEY, JSON.stringify(user));
        }
    }

    public getUser(): any {
        if (typeof localStorage !== 'undefined') {
            const user = localStorage.getItem(USER_KEY);
            if (user) {
                return JSON.parse(user);
            }
        }
        return {};
    }
}