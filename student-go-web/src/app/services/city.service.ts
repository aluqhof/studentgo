import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { EventTypeResponse } from "../models/event-type-response.inteface";
import { CityResponse } from "../models/city-response.interface";

const httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
}

@Injectable({
    providedIn: 'root'
})
export class CityService {

    constructor(private http: HttpClient) { }

    getCities(): Observable<CityResponse[]> {
        return this.http.get<CityResponse[]>(`http://localhost:8080/city/all`);
    }

    downloadCityPhoto(id: number): Observable<Blob> {
        return this.http.get(`http://localhost:8080/city/download-photo/${id}`, {
            responseType: 'blob'
        });
    }
}