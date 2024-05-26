export function convertColorCode(colorCode: string): string {
    return `#${colorCode.slice(4)}`;
}