import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { EventTypeResponse } from "../models/event-type-response.inteface";
import { Observable } from "rxjs";
import { environment } from "../../environments/environment";

const httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
}

@Injectable({
    providedIn: 'root'
})
export class EventTypeService {

    constructor(private http: HttpClient) { }

    getEventTypes(): Observable<EventTypeResponse[]> {
        return this.http.get<EventTypeResponse[]>(`http://localhost:8080/event-type/`);
    }
}