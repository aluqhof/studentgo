import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { StudentShortListResponse } from "../models/student-short-list-response.interface";
import { Observable } from "rxjs";

const httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
}

@Injectable({
    providedIn: 'root'
})
export class StudentService {

    constructor(private http: HttpClient) { }

    searchForStudent(searchTerm: string): Observable<StudentShortListResponse> {
        return this.http.get<StudentShortListResponse>("http://localhost:8080/student/search?term=" + searchTerm)
    }

}