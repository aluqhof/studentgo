import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { PurchaseListResponse } from "../models/purchase-list-response.interface";
import { Observable } from "rxjs";
import { PurchaseDetails } from "../models/purchase-details.interface";
import { PurchaseRequest } from "../models/purchase-request.interface";
import { PurchaseDoneResponse } from "../models/purchase-done-response.interface";

const httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
}

@Injectable({
    providedIn: 'root'
})
export class PurchaseService {

    constructor(private http: HttpClient) { }


    getAllPurchases(page: number, searchTerm: string): Observable<PurchaseListResponse> {
        return this.http.get<PurchaseListResponse>("http://localhost:8080/purchase/all?page=" + page + "&term=" + searchTerm);
    }

    getPurchaseDetails(id: string): Observable<PurchaseDetails> {
        return this.http.get<PurchaseDetails>("http://localhost:8080/purchase/details/" + id);
    }

    makePurchase(request: PurchaseRequest): Observable<PurchaseDoneResponse> {
        return this.http.post<PurchaseDoneResponse>("http://localhost:8080/purchase/create", request);
    }

    editPurchase(id: string, request: PurchaseRequest): Observable<PurchaseDoneResponse> {
        return this.http.put<PurchaseDoneResponse>("http://localhost:8080/purchase/" + id, request)
    }

}