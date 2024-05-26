import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, catchError, map, of } from "rxjs";
import { EventListResponse } from "../models/event-list-response.interface";
import { EventDetailsResponse } from "../models/event-details.interface";

const httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
}

@Injectable({
    providedIn: 'root'
})
export class EventService {

    constructor(private http: HttpClient) { }

    getFutureEventsByOrganizer(): Observable<EventListResponse> {
        return this.http.get<EventListResponse>(`http://localhost:8080/event/organizer`);
    }


    getPastEventsByOrganizer(): Observable<EventListResponse> {
        return this.http.get<EventListResponse>(`http://localhost:8080/event/past/organizer`);
    }

    getEventDetails(eventId: string): Observable<EventDetailsResponse> {
        return this.http.get<EventDetailsResponse>(`http://localhost:8080/event/details/${eventId}`);
    }

    getEventPhoto(eventId: string, index: number) {
        return this.http.get(`http://localhost:8080/event/download-event-photo/${eventId}/number/${index}`, {
            responseType: 'blob'
        });
    }

}