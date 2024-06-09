export interface EventDetailsResponse {
    uuid: string;
    name: string;
    latitude: number;
    longitude: number;
    description: string;
    cityId: string;
    price: number;
    place: string;
    dateTime: Date;
    organizer: Organizer;
    eventType: string[];
    students: Organizer[];
    urlPhotos: string[];
    maxCapacity: number;
}

export interface Organizer {
    id: string;
    name: string;
    username: string;
    userPhoto?: string;
}
