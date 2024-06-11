import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { EventTypeResponse } from "../models/event-type-response.inteface";
import { Observable } from "rxjs";
import { environment } from "../../environments/environment";
import { EventTypeRequest } from "../models/event-type-request.interface";

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

    getEventType(id: number): Observable<EventTypeResponse> {
        return this.http.get<EventTypeResponse>(`http://localhost:8080/event-type/${id}`);
    }

    createEventType(add: EventTypeRequest): Observable<EventTypeRequest> {
        return this.http.post<EventTypeResponse>("http://localhost:8080/event-type/", add);
    }

    editEventType(id: number, edit: EventTypeRequest): Observable<EventTypeRequest> {
        return this.http.put<EventTypeResponse>("http://localhost:8080/event-type/" + id, edit);
    }

    deleteEventType(id: number) {
        return this.http.delete("http://localhost:8080/event-type/" + id);
    }
}