import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomePageComponent } from './ui/home-page/home-page.component';
import { LoginPageComponent } from './ui/login-page/login-page.component';
import { RegisterPageComponent } from './ui/register-page/register-page.component';
import { OrganizerGuard } from './auth.guard';
import { OrganizerDashboardComponent } from './ui/organizer-dashboard/organizer-dashboard.component';
import { OrganizerEventsComponent } from './ui/organizer-events/organizer-events.component';

export const routes: Routes = [
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

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
