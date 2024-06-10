export interface PurchaseDetails {
    purchaseId: string;
    event: Event;
    price: number;
    dateTime: Date;
    student: Student;
}

export interface Event {
    uuid: string;
    name: string;
    latitude: number;
    longitude: number;
    cityId: string;
    dateTime: Date;
}

export interface Student {
    id: string;
    username: string;
    name: string;
}
