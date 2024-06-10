export interface PurchaseListResponse {
    name: string;
    content: Purchase[];
    size: number;
    totalElements: number;
    pageNumber: number;
    first: boolean;
    last: boolean;
}

export interface Purchase {
    purchaseId: string;
    eventId: string;
    eventName: string;
    city: String;
    dateTime: Date;
    student: Student;
}

export interface Student {
    id: string;
    username: string;
    name: string;
}
