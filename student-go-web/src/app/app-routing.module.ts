import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomePageComponent } from './ui/home-page/home-page.component';
import { AdminDashboardComponent } from './ui/admin-dashboard/admin-dashboard.component';
import { AdminGuard, OrganizerGuard } from './auth.guard';
import { AdminEventsComponent } from './ui/admin-events/admin-events.component';
import { AdminPurchasesComponent } from './ui/admin-purchases/admin-purchases.component';
import { AdminUsersComponent } from './ui/admin-users/admin-users.component';
import { AdminOrganizersComponent } from './ui/admin-organizers/admin-organizers.component';
import { AdminCitiesComponent } from './ui/admin-cities/admin-cities.component';
import { AdminEventTypesComponent } from './ui/admin-event-types/admin-event-types.component';
import { CityEventsPageComponent } from './ui/city-events-page/city-events-page.component';

const routes: Routes = [
  { path: 'home', component: HomePageComponent },
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'city/:cityName', component: CityEventsPageComponent },
  {
    path: 'admin',
    children: [
      { path: '', component: AdminDashboardComponent, canActivate: [AdminGuard] },
      { path: 'events', component: AdminEventsComponent, canActivate: [AdminGuard] },
      { path: 'purchases', component: AdminPurchasesComponent, canActivate: [AdminGuard] },
      { path: 'students', component: AdminUsersComponent, canActivate: [AdminGuard] },
      { path: 'organizers', component: AdminOrganizersComponent, canActivate: [AdminGuard] },
      { path: 'cities', component: AdminCitiesComponent, canActivate: [AdminGuard] },
      { path: 'event-types', component: AdminEventTypesComponent, canActivate: [AdminGuard] }
    ]
  },
  {
    path: 'organizer',
    canActivate: [OrganizerGuard],
    children: [
      { path: '', redirectTo: 'events', pathMatch: 'full' },
      { path: 'events', component: AdminEventsComponent },
      { path: 'purchases', component: AdminPurchasesComponent }
    ]
  },
  { path: '**', redirectTo: 'home' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

/**
 * export const routes: Routes = [
  { path: 'home', component: HomePageComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'register', component: RegisterPageComponent },
  { path: 'login', component: LoginPageComponent },
  {
    path: 'admin',
    children: [
      //{ path: 'bikes', component: AdminBikesPageComponent, canActivate: [AuthGuard] },
      //{ path: 'stations', component: AdminStationsPageComponent, canActivate: [AuthGuard] },
      //{ path: 'issues', component: AdminIssuesPageComponent, canActivate: [AuthGuard] },
      //{ path: 'travels', component: PageAdminTravelsComponent, canActivate: [AuthGuard] }
    ]
  },
  {
    path: 'organizer',
    children: [
      { path: 'dashboard', component: OrganizerDashboardComponent, canActivate: [OrganizerGuard] },
      { path: 'events', component: OrganizerEventsComponent, canActivate: [OrganizerGuard] }
    ]
  },
];
 */
