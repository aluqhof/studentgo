export interface StudentItemResponse {
    name: string;
    content: Student[];
    size: number;
    totalElements: number;
    pageNumber: number;
    first: boolean;
    last: boolean;
}

export interface Student {
    id: string;
    username: string;
    email: string;
    name: string;
    description: string;
    userPhoto: string;
    created: Date;
    interests: Interest[];
}

export interface Interest {
    id: number;
    name: string;
    iconRef: string;
    colorCode: string;
}
