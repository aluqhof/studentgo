export interface EventShortListResponse {
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
}
