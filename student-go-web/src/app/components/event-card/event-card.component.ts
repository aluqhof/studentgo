import { Component, Input } from '@angular/core';
import { EventResponse } from '../../models/event-list-response.interface';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-event-card',
  templateUrl: './event-card.component.html',
  styleUrl: './event-card.component.css'
})
export class EventCardComponent {

  @Input() event!: EventResponse;

  constructor(private datePipe: DatePipe) { }


  formatDate(date: string): string {
    const fechaDate = new Date(date);
    return this.datePipe.transform(fechaDate, 'EEE dd MMMM yyyy - HH:mm', 'es')!;
  }

  convertColorCode(colorCode: string): string {
    return `#${colorCode.slice(4)}`;
  }

}
