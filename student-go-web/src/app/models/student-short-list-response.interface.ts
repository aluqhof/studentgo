export interface StudentShortListResponse {
    name: string;
    content: Content[];
    size: number;
    totalElements: number;
    pageNumber: number;
    first: boolean;
    last: boolean;
}

export interface Content {
    id: string;
    username: string;
    name: string;
}
