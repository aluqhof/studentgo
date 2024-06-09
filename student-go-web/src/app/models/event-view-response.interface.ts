export interface EventViewResponse {
    uuid: string;
    name: string;
    latitude: number;
    longitude: number;
    cityId: string;
    dateTime: Date;
    maxCapacity: number;
    eventType: EventType[];
    students: any[];
}

export interface EventType {
    id: number;
    name: string;
    iconRef: string;
    colorCode: string;
}
