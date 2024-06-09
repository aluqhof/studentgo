export interface EventListResponse {
    name: string;
    content: EventResponse[];
    size: number;
    totalElements: number;
    pageNumber: number;
    first: boolean;
    last: boolean;
}

export interface EventResponse {
    uuid: string;
    name: string;
    latitude: number;
    longitude: number;
    cityId: string;
    dateTime: Date;
    maxCapacity: number;
    eventType: EventType[];
    students: Student[];
}

export interface EventType {
    id: number;
    name: string;
    iconRef: string;
    colorCode: string;
    cssColor?: string;
}

export interface Student {
    id: string;
    username: string;
    name: string;
    userPhoto: string;
}
