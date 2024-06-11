import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { EventTypeResponse } from "../models/event-type-response.inteface";
import { CityResponse } from "../models/city-response.interface";
import { UploadResponse } from "../models/upload-response.interface";

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

    getCity(id: number): Observable<CityResponse> {
        return this.http.get<CityResponse>("http://localhost:8080/city/" + id);
    }

    uploadPhoto(file: File, id: number): Observable<UploadResponse> {
        const formData = new FormData();
        formData.append('file', file);

        return this.http.post<UploadResponse>(`http://localhost:8080/city/upload/${id}`, formData);
    }

    createCity(name: string, file: File): Observable<CityResponse> {
        const formData = new FormData();
        formData.append('file', file);

        const headers = new HttpHeaders();
        headers.set('Content-Type', 'multipart/form-data');


        return this.http.post<CityResponse>("http://localhost:8080/city/" + name, formData, { headers: headers });
    }

    editCity(id: number, name: string, file: File): Observable<CityResponse> {
        const formData = new FormData();
        formData.append('file', file);

        const headers = new HttpHeaders();
        headers.set('Content-Type', 'multipart/form-data');


        return this.http.put<CityResponse>("http://localhost:8080/city/" + id + "/name/" + name, formData, { headers: headers });
    }
}