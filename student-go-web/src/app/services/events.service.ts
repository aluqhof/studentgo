import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, catchError, map, of } from "rxjs";
import { EventListResponse } from "../models/event-list-response.interface";
import { EventDetailsResponse } from "../models/event-details.interface";
import { MyPage } from "../models/my-page.interface";
import { EditEventRequest } from "../models/edit-event-request.interface";
import { UploadResponse } from "../models/upload-response.interface";

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

    getUpcomingEvents(currentPage: number): Observable<MyPage> {
        return this.http.get<MyPage>(`http://localhost:8080/event/upcoming?page=${currentPage}`);
    }

    editEventAdmin(id: string, edit: EditEventRequest) {
        return this.http.put<EventDetailsResponse>(`http://localhost:8080/event/edit-admin/${id}`,
            edit
        )
    }

    uploadEventPhotos(files: File[], idEvent: string): Observable<UploadResponse> {
        const formData = new FormData();
        files.forEach(file => {
            formData.append('files', file);
        });

        return this.http.post<UploadResponse>(`http://localhost:8080/event/upload/event-photos/${idEvent}`, formData);
    }

    deleteEventPhoto(id: string, index: number) {
        return this.http.get(`http://localhost:8080/event/delete-photo/${id}/number/${index}`)
    }


}