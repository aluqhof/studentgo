import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { OrganizerList } from "../models/organizer-list.interface";
import { Observable } from "rxjs";
import { OrganizerResponse } from "../models/organizer-response.interface";
import { OrganizerEditRequest } from "../models/organizer-edit-request.interface";

@Injectable({
    providedIn: 'root'
})
export class OrganizerService {

    constructor(private http: HttpClient) { }

    findAllOrganizer(page: number): Observable<OrganizerList> {
        return this.http.get<OrganizerList>("http://localhost:8080/organizer/all?page=" + page);
    }

    getOrganizer(id: string): Observable<OrganizerResponse> {
        return this.http.get<OrganizerResponse>("http://localhost:8080/organizer/" + id);
    }

    editOrganizer(id: string, edit: OrganizerEditRequest) {
        return this.http.put("http://localhost:8080/organizer/" + id, edit)
    }

    createOrganizer(add: OrganizerEditRequest) {
        return this.http.post("http://localhost:8080/auth/register-organizer", add)
    }
}