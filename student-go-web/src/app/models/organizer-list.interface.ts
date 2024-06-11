export interface OrganizerList {
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
    username: string;
    email: string;
    name: string;
    userPhoto: string;
    created: Date;
    business: string;
}
