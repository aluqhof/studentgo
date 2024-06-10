import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, catchError, map, of } from "rxjs";
import { EventListResponse } from "../models/event-list-response.interface";
import { EventDetailsResponse } from "../models/event-details.interface";
import { MyPage } from "../models/my-page.interface";
import { EditEventRequest } from "../models/edit-event-request.interface";
import { UploadResponse } from "../models/upload-response.interface";
import { EventViewResponse } from "../models/event-view-response.interface";
import { Event } from "../models/purchase-details.interface";
import { EventShortListResponse } from "../models/event-short-list-response.interface";

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

    createEvent(add: EditEventRequest, files: File[]): Observable<EventViewResponse> {
        const formData = new FormData();
        //const addEventRequestBlob = new Blob([JSON.stringify(add)], { type: 'application/json' });
        formData.append('addEventRequest', JSON.stringify(add));

        files.forEach(file => {
            formData.append('files', file);
        });

        const headers = new HttpHeaders();
        headers.set('Content-Type', 'multipart/form-data');


        return this.http.post<EventViewResponse>("http://localhost:8080/event/", formData, { headers: headers });
    }

    searchForEvent(searchTerm: string): Observable<EventShortListResponse> {
        return this.http.get<EventShortListResponse>("http://localhost:8080/event/search?term=" + searchTerm)
    }

}