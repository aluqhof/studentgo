import { Component, OnChanges, SimpleChanges, inject } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { EventService } from '../../services/events.service';
import { EventResponse } from '../../models/event-list-response.interface';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-city-events-page',
  templateUrl: './city-events-page.component.html',
  styleUrl: './city-events-page.component.css'
})
export class CityEventsPageComponent {

  city!: string;
  private routeSub!: Subscription;
  eventList: EventResponse[] = [];

  constructor(
    private sanitizer: DomSanitizer,
    private router: Router,
    private route: ActivatedRoute,
    private eventService: EventService,
    private datePipe: DatePipe
  ) { }

  ngOnInit(): void {
    this.routeSub = this.route.paramMap.subscribe(params => {
      this.city = params.get('cityName') ?? '';
      this.loadEvents();
    });
  }

  loadEvents(): void {
    this.eventService.getUpcomingEventsByCity(this.city).subscribe({
      next: (data) => {
        this.eventList = data;
      },
      error: (error) => {
        console.error('Error getting events:', error);
      }
    });
  }

  formatDate(date: string): string {
    const fechaDate = new Date(date);
    return this.datePipe.transform(fechaDate, 'EEE dd MMMM yyyy - HH:mm', 'es')!;
  }

  ngOnDestroy(): void {
    if (this.routeSub) {
      this.routeSub.unsubscribe();
    }
  }

}
