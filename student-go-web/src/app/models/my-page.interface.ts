export interface MyPage {
    name: string;
    content: Content[];
    size: number;
    totalElements: number;
    pageNumber: number;
    first: boolean;
    last: boolean;
}

export interface Content {
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
}

export interface Student {
    id: string;
    username: string;
    name: string;
    userPhoto: UserPhoto;
}

export enum UserPhoto {
    NophotoPNG = "nophoto.png",
}
