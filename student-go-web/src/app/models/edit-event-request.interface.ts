export interface EditEventRequest {
    name: string;
    dateTime: string;
    description: string;
    price: number;
    maxCapacity: number;
    cityId: String;
    latitude: number;
    longitude: number;
    eventTypes: String[];
}
