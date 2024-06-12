export interface OrganizerPageResponse {
    name: string;
    content: Organizer[];
    size: number;
    totalElements: number;
    pageNumber: number;
    first: boolean;
    last: boolean;
}

export interface Organizer {
    id: string;
    name: string;
    username: string;
}
