import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { StudentShortListResponse } from "../models/student-short-list-response.interface";
import { Observable } from "rxjs";
import { Student, StudentItemResponse } from "../models/student-item-response.interface";
import { UploadResponse } from "../models/upload-response.interface";
import { StudentRequest } from "../models/student-request.interface";

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

    findAllStudents(page: number, searchTerm: string): Observable<StudentItemResponse> {
        return this.http.get<StudentItemResponse>("http://localhost:8080/student/all?page=" + page + "&term=" + searchTerm)
    }

    getStudentById(id: string): Observable<Student> {
        return this.http.get<Student>("http://localhost:8080/student/" + id);
    }

    getUserPhoto(id: string) {
        return this.http.get(`http://localhost:8080/download-profile-photo/${id}`, {
            responseType: 'blob'
        });
    }

    uploadProfilePhoto(file: File, id: string): Observable<UploadResponse> {
        const formData = new FormData();
        formData.append('file', file);

        return this.http.post<UploadResponse>(`http://localhost:8080/upload-profile-image/${id}`, formData);
    }

    editStudent(id: string, edit: StudentRequest): Observable<Student> {
        return this.http.put<Student>("http://localhost:8080/student/" + id, edit)
    }
}